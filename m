Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754819Ab2CDTfn (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Mar 2012 14:35:43 -0500
Received: from mx1.redhat.com ([209.132.183.28]:28408 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754797Ab2CDTfm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Mar 2012 14:35:42 -0500
Date: Sun, 4 Mar 2012 14:35:27 -0500 (EST)
From: Mikulas Patocka <mpatocka@redhat.com>
X-X-Sender: mpatocka@file.rdu.redhat.com
To: Mandeep Singh Baines <msb@chromium.org>
cc: linux-kernel@vger.kernel.org, dm-devel@redhat.com,
        Alasdair G Kergon <agk@redhat.com>, Will Drewry <wad@chromium.org>,
        Elly Jones <ellyjones@chromium.org>, Milan Broz <mbroz@redhat.com>,
        Olof Johansson <olofj@chromium.org>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: userspace hashing utility for dm-verity
In-Reply-To: <Pine.LNX.4.64.1203031340340.10937@file.rdu.redhat.com>
Message-ID: <Pine.LNX.4.64.1203041419180.22461@file.rdu.redhat.com>
References: <1330648393-20692-1-git-send-email-msb@chromium.org>
 <Pine.LNX.4.64.1203031340340.10937@file.rdu.redhat.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an userspace utility that creates or verifies hashes for the 
verity target.

The original utility was created by Google and it is located at 
http://git.chromium.org/chromiumos/platform/dm-verity.git

The original utility has some problems:
* the code is really overengineered, they took the kernel code and built 
  an emulation layer in userspace that emulates some of the kernel 
  functions
* it dosn't use library implementations of hash functions, rather it 
  provides its own md5, sha1, sha256 and sha512 implementation
* it is not portable (produces bad result on big-endian machines)

This is much smaller implementation that is portable and uses the crypto 
library.

This code creates compatible format with the original Google code under 
these conditions:
- data block size and hash block size are 4096
- salt has exactly 32 bytes (64 hex digits)

Example use:
Create filesystem on /dev/sdc2 and fill it with some data. Block size must 
be 4096
Unmount the filesystem

Run: ./verity -c /dev/sdc2 /dev/sdc3 sha256 --salt
1234000000000000000000000000000000000000000000000000000000000000
- This creates hash tree on /dev/sdc3 and prints the root block hash

Run: dmsetup -r create verity --table "0 `blockdev --getsize /dev/sdc2` 
verity 0 /dev/sdc2 /dev/sdc3 0 4096 sha256 
f4c97f1f2e6b6757d033b2062268e0b6b42cbe4ff5a5fcc0017305b145cae4de 
1234000000000000000000000000000000000000000000000000000000000000 "
(note: use the real hash reported by "verity" tool instead of f4c9...)

mount -o ro -t ext2 /dev/mapper/verity /mnt/test

Now, the device is mounted and dm-verity target is verifying the hashes.
All data integrity depends only on the root hash 
(f4c97f1f2e6b6757d033b2062268e0b6b42cbe4ff5a5fcc0017305b145cae4de) and 
salt (1234000000000000000000000000000000000000000000000000000000000000). 
If either the data or hash partitions become silently corrupted and 
you read invalid data, dm-verity will return -EIO.

Mikulas

---

/* link with -lpopt -lcrypto */

#define _FILE_OFFSET_BITS	64

#include <stdio.h>
#include <stdlib.h>
#include <stdarg.h>
#include <unistd.h>
#include <errno.h>
#include <string.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <sys/ioctl.h>
#include <sys/mount.h>
#include <popt.h>
#include <openssl/evp.h>

#define DEFAULT_BLOCK_SIZE	4096
#define DM_VERITY_MAX_LEVELS	63

#define MODE_VERIFY	0
#define MODE_CREATE	1

static int mode = -1;

static const char *data_device;
static const char *hash_device;
static const char *hash_algorithm;
static const char *root_hash;

static int data_block_size = 0;
static int hash_block_size = 0;
static long long hash_start = 0;
static long long data_blocks = 0;
static const char *salt_string = NULL;

static FILE *data_file;
static FILE *hash_file;

static off_t data_file_blocks;
static off_t hash_file_blocks;
static off_t used_hash_blocks;

static const EVP_MD *evp;

static unsigned char *root_hash_bytes;
static unsigned char *calculated_digest;

static unsigned char *salt_bytes;
static unsigned salt_size;

static unsigned digest_size;
static unsigned char levels;
static unsigned char hash_per_block_bits;

static off_t hash_level_block[DM_VERITY_MAX_LEVELS];
static off_t hash_level_size[DM_VERITY_MAX_LEVELS];

static int retval = 0;

static void help(poptContext popt_context,
		enum poptCallbackReason reason,
		struct poptOption *key,
		const char *arg,
		void *data)
{
	poptPrintHelp(popt_context, stdout, 0);
	exit(0);
}

static struct poptOption popt_help_options[] = {
	{ NULL,			0,	POPT_ARG_CALLBACK, help, 0, NULL, NULL },
	{ "help",		'?',	POPT_ARG_NONE, NULL, 0, "Show help", NULL },
	POPT_TABLEEND
};

static struct poptOption popt_options[] = {
	{ NULL,			'\0', POPT_ARG_INCLUDE_TABLE, popt_help_options, 0, NULL, NULL },
	{ "create",		'c',	POPT_ARG_VAL, &mode, MODE_CREATE, "Create hash", NULL },
	{ "verify",		'v',	POPT_ARG_VAL, &mode, MODE_VERIFY, "Verify integrity", NULL },
	{ "data-block-size",	0, 	POPT_ARG_INT, &data_block_size, 0, "Block size on the data device", "bytes" },
	{ "hash-block-size",	0, 	POPT_ARG_INT, &hash_block_size, 0, "Block size on the hash device", "bytes" },
	{ "hash-start",		0,	POPT_ARG_LONGLONG, &hash_start, 0, "Starting sector on the hash device", "sectors" },
	{ "data-blocks",	0,	POPT_ARG_LONGLONG, &data_blocks, 0, "The number of blocks in the data file", "blocks" },
	{ "salt",		0,	POPT_ARG_STRING, &salt_string, 0, "Salt", "hex string" },
	POPT_TABLEEND
};

static void exit_err(const char *msg, ...)
{
	va_list args;
	va_start(args, msg);
	vfprintf(stderr, msg, args);
	va_end(args);
	fputc('\n', stderr);
	exit(2);
}

static void stream_err(FILE *f, const char *msg)
{
	if (ferror(f)) {
		perror(msg);
		exit(2);
	} else if (feof(f)) {
		exit_err("eof on %s", msg);
	} else {
		exit_err("unknown error on %s", msg);
	}
}

static void *xmalloc(size_t s)
{
	void *ptr = malloc(s);
	if (!ptr) exit_err("out of memory");
	return ptr;
}

static off_t get_size(FILE *f, const char *name)
{
	struct stat st;
	int h = fileno(f);
	if (h < 0) {
		perror("fileno");
		exit(2);
	}
	if (fstat(h, &st)) {
		perror("fstat");
		exit(2);
	}
	if (S_ISREG(st.st_mode)) {
		return st.st_size;
	} else if (S_ISBLK(st.st_mode)) {
		unsigned long long size64;
		unsigned long sizeul;
		if (!ioctl(h, BLKGETSIZE64, &size64)) {
			return_size64:
			if ((off_t)size64 < 0 || (off_t)size64 != size64) {
				size_overflow:
				exit_err("%s: device size overflow", name);
			}
			return size64;
		}
		if (!ioctl(h, BLKGETSIZE, &sizeul)) {
			size64 = (unsigned long long)sizeul * 512;
			if (size64 / 512 != sizeul) goto size_overflow;
			goto return_size64;
		}
		perror("BLKGETSIZE");
		exit(2);
	} else {
		exit_err("%s is not a file or a block device", name);
	}
	return -1;	/* never reached, shut up warning */
}

static void block_fseek(FILE *f, off_t block, int block_size)
{
	unsigned long long pos = (unsigned long long)block * block_size;
	if (pos / block_size != block ||
	    (off_t)pos < 0 ||
	    (off_t)pos != pos)
		exit_err("seek position overflow");
	if (fseeko(f, pos, SEEK_SET)) {
		perror("fseek");
		exit(2);
	}
}

static off_t verity_position_at_level(off_t block, int level)
{
	return block >> (level * hash_per_block_bits);
}

static void calculate_positions(void)
{
	unsigned long long hash_position;
	int i;

	hash_per_block_bits = 0;
	while (((hash_block_size / digest_size) >> hash_per_block_bits) > 1)
		hash_per_block_bits++;
	if (!hash_per_block_bits)
		exit_err("at least two hashes must fit in a hash file block");
	levels = 0;

	if (data_file_blocks) {
		while (hash_per_block_bits * levels < 64 &&
		       (unsigned long long)(data_file_blocks - 1) >>
		       (hash_per_block_bits * levels))
			levels++;
	}

	if (levels > DM_VERITY_MAX_LEVELS) exit_err("too many tree levels");

	hash_position = hash_start * 512 / hash_block_size;
	for (i = levels - 1; i >= 0; i--) {
		off_t s;
		hash_level_block[i] = hash_position;
		s = verity_position_at_level(data_file_blocks, i);
		s = (s >> hash_per_block_bits) +
		    !!(s & ((1 << hash_per_block_bits) - 1));
		hash_level_size[i] = s;
		if (hash_position + s < hash_position ||
		    (off_t)(hash_position + s) < 0 ||
		    (off_t)(hash_position + s) != hash_position + s)
			exit_err("hash device offset overflow");
		hash_position += s;
	}
	used_hash_blocks = hash_position;
}

static void create_or_verify_stream(FILE *rd, FILE *wr, int block_size, off_t blocks)
{
	unsigned char *left_block = xmalloc(hash_block_size);
	unsigned char *data_buffer = xmalloc(block_size);
	unsigned char *read_digest = mode == MODE_VERIFY ? xmalloc(digest_size) : NULL;
	off_t blocks_to_write = (blocks >> hash_per_block_bits) +
				!!(blocks & ((1 << hash_per_block_bits) - 1));
	EVP_MD_CTX ctx;
	EVP_MD_CTX_init(&ctx);
	memset(left_block, 0, hash_block_size);
	while (blocks_to_write--) {
		unsigned x;
		unsigned left_bytes;
		for (x = 0; x < 1 << hash_per_block_bits; x++) {
			if (!blocks)
				break;
			blocks--;
			if (fread(data_buffer, block_size, 1, rd) != 1)
				stream_err(rd, "read");
			if (EVP_DigestInit_ex(&ctx, evp, NULL) != 1)
				exit_err("EVP_DigestInit_ex failed");
			if (EVP_DigestUpdate(&ctx, data_buffer, block_size) != 1)
				exit_err("EVP_DigestUpdate failed");
			if (EVP_DigestUpdate(&ctx, salt_bytes, salt_size) != 1)
				exit_err("EVP_DigestUpdate failed");
			if (EVP_DigestFinal_ex(&ctx, calculated_digest, NULL) != 1)
				exit_err("EVP_DigestFinal_ex failed");
			if (!wr)
				break;
			if (mode == MODE_VERIFY) {
				if (fread(read_digest, digest_size, 1, wr) != 1)
					stream_err(wr, "read");
				if (memcmp(read_digest, calculated_digest, digest_size)) {
					retval = 1;
					fprintf(stderr, "verification failed at position %lld in %s file\n", (long long)ftello(rd) - block_size, rd == data_file ? "data" : "metadata");
				}
			} else {
				if (fwrite(calculated_digest, digest_size, 1, wr) != 1)
					stream_err(wr, "write");
			}
		}
		left_bytes = hash_block_size - x * digest_size;
		if (left_bytes && wr) {
			if (mode == MODE_VERIFY) {
				if (fread(left_block, left_bytes, 1, wr) != 1)
					stream_err(wr, "read");
				for (x = 0; x < left_bytes; x++) if (left_block[x]) {
					retval = 1;
					fprintf(stderr, "spare area is not zeroed at position %lld\n", (long long)ftello(wr) - left_bytes);
				}
			} else {
				if (fwrite(left_block, left_bytes, 1, wr) != 1)
					stream_err(wr, "write");
			}
		}
	}
	if (mode != MODE_VERIFY && wr) {
		if (fflush(wr)) {
			perror("fflush");
			exit(1);
		}
		if (ferror(wr)) {
			stream_err(wr, "write");
		}
	}
	if (EVP_MD_CTX_cleanup(&ctx) != 1)
		exit_err("EVP_MD_CTX_cleanup failed");
	free(left_block);
	free(data_buffer);
	if (mode == MODE_VERIFY) free(read_digest);
}

static void create_or_verify(void)
{
	int i;
	for (i = 0; i < levels; i++) {
		block_fseek(hash_file, hash_level_block[i], hash_block_size);
		if (!i) {
			block_fseek(data_file, 0, data_block_size);
			create_or_verify_stream(data_file, hash_file, data_block_size, data_file_blocks);
		} else {
			FILE *hash_file_2 = fopen(hash_device, "r");
			if (!hash_file_2) {
				perror(hash_device);
				exit(2);
			}
			block_fseek(hash_file_2, hash_level_block[i - 1], hash_block_size);
			create_or_verify_stream(hash_file_2, hash_file, hash_block_size, hash_level_size[i - 1]);
			fclose(hash_file_2);
		}
	}

	if (levels) {
		block_fseek(hash_file, hash_level_block[levels - 1], hash_block_size);
		create_or_verify_stream(hash_file, NULL, hash_block_size, 1);
	} else {
		block_fseek(data_file, 0, data_block_size);
		create_or_verify_stream(data_file, NULL, data_block_size, data_file_blocks);
	}

	if (mode == MODE_VERIFY) {
		if (memcmp(calculated_digest, root_hash_bytes, digest_size)) {
			fprintf(stderr, "verification failed in the root block\n");
			retval = 1;
		}
		if (!retval)
			fprintf(stderr, "hash successfully verified\n");
	} else {
		if (fsync(fileno(hash_file))) {
			perror("fsync");
			exit(1);
		}
		printf("hash device size: %llu\n", (unsigned long long)used_hash_blocks * hash_block_size);
		printf("data block size %u, hash block size %u, %u tree levels\n", data_block_size, hash_block_size, levels);
		printf("root hash: ");
		for (i = 0; i < digest_size; i++) printf("%02x", calculated_digest[i]);
		printf("\n");
		printf("device mapper target line: 0 %llu verity 0 %s %s %llu %u %s ",
			(unsigned long long)data_file_blocks * data_block_size / 512,
			data_device,
			hash_device,
			hash_start,
			data_block_size,
			hash_algorithm
			);
		for (i = 0; i < digest_size; i++) printf("%02x", calculated_digest[i]);
		printf(" ");
		if (!salt_size) printf("-");
		else for (i = 0; i < salt_size; i++) printf("%02x", salt_bytes[i]);
		if (hash_block_size != data_block_size) printf(" %u", hash_block_size);
		printf("\n");
		if (data_block_size == 4096 && hash_block_size == 4096 && salt_size == 32)
			printf("compatible with the original Google code\n");
		else {
			printf("incompatible with the original Google code:\n");
			if (!(data_block_size == 4096 && hash_block_size == 4096)) printf("\tdata and hash block size must be 4096\n");
			if (!(salt_size == 32)) printf("\tsalt must have exactly 32 bytes (64 hex digits)\n");
		}
	}
}

static void get_hex(const char *string, unsigned char **result, size_t len, const char *description)
{
	size_t rl = strlen(string);
	unsigned u;
	if (strspn(string, "0123456789ABCDEFabcdef") != rl)
		exit_err("invalid %s", description);
	if (rl != len * 2)
		exit_err("invalid length of %s", description);
	*result = xmalloc(len);
	memset(*result, 0, len);
	for (u = 0; u < rl; u++) {
		unsigned char c = (string[u] & 15) + (string[u] > '9' ? 9 : 0);
		(*result)[u / 2] |= c << (((u & 1) ^ 1) << 2);
	}
}

int main(int argc, const char **argv)
{
	poptContext popt_context;
	int r;
	const char *s;

	popt_context = poptGetContext("verity", argc, argv, popt_options, 0);

	poptSetOtherOptionHelp(popt_context, "[-c | -v] <data device> <hash device> <algorithm> [<root hash> if verifying] [OPTION...]");

	if (argc <= 1) {
		poptPrintHelp(popt_context, stdout, 0);
		exit(1);
	}

	r = poptGetNextOpt(popt_context);
	if (r < -1) exit_err("bad option %s", poptBadOption(popt_context, 0));

	if (mode < 0) exit_err("verify or create mode not specified");

	if (!data_block_size) data_block_size = DEFAULT_BLOCK_SIZE;
	if (!hash_block_size) hash_block_size = data_block_size;

	if (data_block_size <= 0 || (data_block_size & (data_block_size - 1)))
		exit_err("invalid data block size");

	if (hash_block_size <= 0 || (hash_block_size & (hash_block_size - 1)))
		exit_err("invalid hash block size");

	if (hash_start < 0 ||
	    (unsigned long long)hash_start * 512 / 512 != hash_start) exit_err("invalid hash start");
	if (data_blocks < 0 || (off_t)data_blocks < 0 || (off_t)data_blocks != data_blocks) exit_err("invalid number of data blocks");

	data_device = poptGetArg(popt_context);
	if (!data_device) exit_err("data device is missing");

	hash_device = poptGetArg(popt_context);
	if (!hash_device) exit_err("metadata device is missing");

	hash_algorithm = poptGetArg(popt_context);
	if (!hash_algorithm) exit_err("hash algorithm not specified");

	if (mode == MODE_VERIFY) {
		root_hash = poptGetArg(popt_context);
		if (!root_hash) exit_err("root hash not specified");
	}

	s = poptGetArg(popt_context);
	if (s) exit_err("extra argument %s", s);

	data_file = fopen(data_device, "r");
	if (!data_file) {
		perror(data_device);
		exit(2);
	}

	hash_file = fopen(hash_device, mode == MODE_VERIFY ? "r" : "r+");
	if (!hash_file && errno == ENOENT && mode != MODE_VERIFY)
		hash_file = fopen(hash_device, "w+");
	if (!hash_file) {
		perror(hash_device);
		exit(2);
	}

	data_file_blocks = get_size(data_file, data_device) / data_block_size;
	hash_file_blocks = get_size(hash_file, hash_device) / hash_block_size;

	if ((unsigned long long)hash_start * 512 % hash_block_size) exit_err("hash start not aligned on block size");
	if (data_file_blocks < data_blocks) exit_err("data file is too small");
	if (data_blocks) data_file_blocks = data_blocks;

	OpenSSL_add_all_digests();
	evp = EVP_get_digestbyname(hash_algorithm);
	if (!evp) exit_err("hash algorithm %s not found", hash_algorithm);
	digest_size = EVP_MD_size(evp);

	salt_size = 0;
	if (salt_string && *salt_string) {
		salt_size = strlen(salt_string) / 2;
		get_hex(salt_string, &salt_bytes, salt_size, "salt");
	}

	calculated_digest = xmalloc(digest_size);

	if (mode == MODE_VERIFY) {
		get_hex(root_hash, &root_hash_bytes, digest_size, "root_hash");
	}

	calculate_positions();

	create_or_verify();

	fclose(data_file);
	fclose(hash_file);

	if (salt_size)
		free(salt_bytes);
	free(calculated_digest);
	if (mode == MODE_VERIFY)
		free(root_hash_bytes);
	poptFreeContext(popt_context);

	return retval;
}
