Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754978Ab1KUNih (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Nov 2011 08:38:37 -0500
Received: from mx1.redhat.com ([209.132.183.28]:36665 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754259Ab1KUNig (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Nov 2011 08:38:36 -0500
Date: Mon, 21 Nov 2011 14:40:57 +0100
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: =?utf-8?B?VG9tw6HFoSBKYW5vdcWhZWs=?= <tomi@nomi.cz>
Cc: linux-kernel@vger.kernel.org, Wey-Yi Guy <wey-yi.w.guy@intel.com>,
        linux-wireless@vger.kernel.org
Subject: Re: iwlagn: memory corruption with WPA enterprise
Message-ID: <20111121134056.GB4010@redhat.com>
References: <20111110114732.GA2217@redhat.com>
 <20111110125347.GA29415@nomi.cz>
 <20111110160703.GA2775@redhat.com>
 <20111110163051.GA24533@nomi.cz>
 <20111111054731.GA2292@redhat.com>
 <20111111150105.GA25437@nomi.cz>
 <20111114140714.GD2513@redhat.com>
 <20111119181106.GA5515@nomi.cz>
 <20111121130527.GA4010@redhat.com>
 <20111121130916.GA11136@nomi.cz>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="0F1p//8PRICkK4MW"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20111121130916.GA11136@nomi.cz>
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--0F1p//8PRICkK4MW
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit

On Mon, Nov 21, 2011 at 02:09:16PM +0100, Tomáš Janoušek wrote:
> On Mon, Nov 21, 2011 at 02:05:28PM +0100, Stanislaw Gruszka wrote:
> > The farther we get the problem is more and more strange.
> > 
> > Device that write to wrong address, would generate:
> > 
> > DMAR:[DMA Write] Request device [00:02.0] fault addr 6df084000
> > DMAR:[fault reason 05] PTE Write access is not set
> 
> And that's exactly what happens if I don't disable firewire-ohci, because of
> that stupid Ricoh multifunction blah blah issue.

So maybe problem is caused by Ricoh, not by iwlagn. But if so 
why blacklisting iwlagn help? Wired. Did you disable firewire in
BIOS, or just blacklist module?

> > Try "dmesg | grep DMAR" to see if DMA remapping is really is
> > in use. 
> 
> Well, this message is not printed, but as I said, loading firewire-ohci
> triggers DMAR faults, so it should be in use anyway.

So IOMMU is in use and it does not prevent corruption, crap.

Ok maybe let's try to find some better reproducer first.
I wrote simple program that fill memory with some pattern, and
then check every one second if pattern is still there.
It can be used like:
./checkmem 100M 30M
where first argument is size of memory it will alloc and check,
second specify number of internal loops to make cpu busy (bigger
value will cause more cpu power consumption). Many instances of
the program can be running at once.

Tomáš, please try to reproduce with that program, I'm attaching
it. When corruption will be detected, checkmem will print invalid
values, maybe would be possible to find out what contents is
written to memory.

Stanislaw

--0F1p//8PRICkK4MW
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="checkmem.c"

#include <stdio.h>
#include <unistd.h>
#include <stdlib.h>
#include <signal.h>
#include <sys/time.h>

unsigned int pattern;
unsigned int *ptr;
int finish = 0;
long size = 1 * 1024 * 1024;
long loops = 10 * 1024 * 1024;

void initArgs(int argc, char *argv[])
{
	int rc, i;
	char suf;
	long arg;

	if (argc > 3)
		goto exit;

	for (i = 1; i < argc; i++) {
		rc = sscanf(argv[i], "%ld%c", &arg, &suf);
		if (rc == 2) {
			switch (suf) {
			case 'M':
			case 'm':
				arg *= 1024 * 1024;
				break;
			case 'K':
			case 'k':
				arg *= 1024;
				break;
			default:
				goto exit;
			}
		} else if (rc != 1)
			goto exit;

		if (i == 1)
			size = arg;
		else if (i == 2)
			loops = arg;
	}

	printf("size %ld loops %ld\n", size, loops);
	return;

exit:		
	fprintf(stderr, "usage: %s size loops\n", argv[0]);
	exit(1);
}

void initPattern()
{ 
	struct timeval tv = { 0xdeadbeaf, 0 };
	
	gettimeofday(&tv, NULL);
	srand(tv.tv_sec ^ tv.tv_usec);
	pattern = rand();
	printf("pattern %08x\n", pattern);
}

void initChunk()
{
	int i;
	
	ptr = malloc(size);
	if (ptr == NULL) {
		fprintf(stderr, "fail to allocate mem\n");
		fflush(stderr);
		exit(1);
	}

	for (i = 0; i < size/4; i++)
		ptr[i] = pattern;
	
	printf("initialized %d MB\n", size/(1024*1024));
	fflush(stdout);
}


void sig_handler()
{
	finish = 1;
}

void checkChunks()
{
	int i;
	int ok = 1;
	int printed = 0;

	for (i = 0; i < size/4; i++) {
		if (ptr[i] != pattern) {
			if (!printed) {
				fprintf(stderr, "memory corruption!\n");
				fflush(stderr);
				printed = 1;
			}
			fprintf(stderr, "%p: 0x%08x\n", &ptr[i], ptr[i]);
			fflush(stderr);
			ok = 0;
		}
	}

	if (ok) {
		printf("check ok\n");
		fflush(stdout);
	} else {
		/* In case of memory corruption sleep forever */
		while (1)
			sleep(1);
	}
}

void alarm_handler()
{
	checkChunks();
	alarm(1);
}

#define barrier() __asm__ __volatile__("": : :"memory")

void use_cpu()
{
	long i;
	static long a = 0;

	for (i = 0; i < loops; i++) {
		a++;
		barrier();
		a += 3;
		barrier();
		a += 10;
		barrier();
	}
}

int main(int argc, char *argv[])
{
	initArgs(argc, argv);
	initPattern();	
	initChunk();

	signal(SIGUSR1, sig_handler);
	signal(SIGINT, sig_handler);
	signal(SIGTERM, sig_handler);

	signal(SIGALRM, alarm_handler);
	alarm(1);

	while (finish == 0) {
		use_cpu();
		sleep(1);
	}

	checkChunks();

	return 0;
}

--0F1p//8PRICkK4MW--
