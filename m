Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759495Ab1IIRDR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Sep 2011 13:03:17 -0400
Received: from smtp-out.google.com ([216.239.44.51]:39083 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758560Ab1IIRDQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Sep 2011 13:03:16 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=dkim-signature:mime-version:in-reply-to:references:date:
	message-id:subject:from:to:cc:content-type:
	content-transfer-encoding:x-system-of-record;
	b=AHeimtlFPecyMoiV7JASa9ZVcnakSZFWzF/QKjmmwMBIsTbxccS3VT5u9XBLRBBkz
	29uXh3svm4YTCmGzYX4Jg==
MIME-Version: 1.0
In-Reply-To: <4cc1af3c.8ee7d80a.5a28.ffff868e@mx.google.com>
References: <4cc1af3c.8ee7d80a.5a28.ffff868e@mx.google.com>
Date: Fri, 9 Sep 2011 19:03:12 +0200
Message-ID: <CABPqkBTvz+WCDCknMn4wzr8LU__N199qaPqKH43q6EHadDKQSg@mail.gmail.com>
Subject: Re: [PATCH] perf: fix issue with binaries using 16-bytes buildids (v2)
From: Stephane Eranian <eranian@google.com>
To: linux-kernel@vger.kernel.org
Cc: acme@redhat.com, peterz@infradead.org, mingo@elte.hu
Content-Type: text/plain; charset=UTF-8
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id p89H3R8q032276

Arnaldo,

To my surprise, this patch from Last October is STILL not in.
People are reporting issues with perf related to md5 buildids..


On Fri, Oct 22, 2010 at 5:25 PM, Stephane Eranian <eranian@google.com> wrote:
> Buildid can vary in size. According to the man page of ld, buildid can
> be 160 bits (sha1) or 128 bits (md5, uuid). Perf assumes buildid size
> of 20 bytes (160 bits) regardless. When dealing with md5 buildids, it
> would thus read more than needed and that would cause mismatches and
> samples without symbols.
>
> This patch fixes this by taking into account the actual buildid size
> as encoded int he section header. The leftover bytes are also cleared.
>
> This second version fixes a minor issue with the memset() base position.
>
> Signed-off-by: Stephane Eranian <eranian@google.com>
>
> ---
>
> diff --git a/tools/perf/util/symbol.c b/tools/perf/util/symbol.c
> index b39f499..b4fdb91 100644
> --- a/tools/perf/util/symbol.c
> +++ b/tools/perf/util/symbol.c
> @@ -1027,8 +1027,7 @@ static int dso__load_sym(struct dso *self, struct map *map, const char *name,
>        if (self->has_build_id) {
>                u8 build_id[BUILD_ID_SIZE];
>
> -               if (elf_read_build_id(elf, build_id,
> -                                     BUILD_ID_SIZE) != BUILD_ID_SIZE)
> +               if (elf_read_build_id(elf, build_id, BUILD_ID_SIZE) < 0)
>                        goto out_elf_end;
>
>                if (!dso__build_id_equal(self, build_id))
> @@ -1287,8 +1286,8 @@ static int elf_read_build_id(Elf *elf, void *bf, size_t size)
>        ptr = data->d_buf;
>        while (ptr < (data->d_buf + data->d_size)) {
>                GElf_Nhdr *nhdr = ptr;
> -               int namesz = NOTE_ALIGN(nhdr->n_namesz),
> -                   descsz = NOTE_ALIGN(nhdr->n_descsz);
> +               size_t namesz = NOTE_ALIGN(nhdr->n_namesz),
> +                      descsz = NOTE_ALIGN(nhdr->n_descsz);
>                const char *name;
>
>                ptr += sizeof(*nhdr);
> @@ -1297,8 +1296,10 @@ static int elf_read_build_id(Elf *elf, void *bf, size_t size)
>                if (nhdr->n_type == NT_GNU_BUILD_ID &&
>                    nhdr->n_namesz == sizeof("GNU")) {
>                        if (memcmp(name, "GNU", sizeof("GNU")) == 0) {
> -                               memcpy(bf, ptr, BUILD_ID_SIZE);
> -                               err = BUILD_ID_SIZE;
> +                               size_t sz = min(size, descsz);
> +                               memcpy(bf, ptr, sz);
> +                               memset(bf + sz, 0, size - sz);
> +                               err = descsz;
>                                break;
>                        }
>                }
> @@ -1350,7 +1351,7 @@ int sysfs__read_build_id(const char *filename, void *build_id, size_t size)
>        while (1) {
>                char bf[BUFSIZ];
>                GElf_Nhdr nhdr;
> -               int namesz, descsz;
> +               size_t namesz, descsz;
>
>                if (read(fd, &nhdr, sizeof(nhdr)) != sizeof(nhdr))
>                        break;
> @@ -1359,15 +1360,16 @@ int sysfs__read_build_id(const char *filename, void *build_id, size_t size)
>                descsz = NOTE_ALIGN(nhdr.n_descsz);
>                if (nhdr.n_type == NT_GNU_BUILD_ID &&
>                    nhdr.n_namesz == sizeof("GNU")) {
> -                       if (read(fd, bf, namesz) != namesz)
> +                       if (read(fd, bf, namesz) != (ssize_t)namesz)
>                                break;
>                        if (memcmp(bf, "GNU", sizeof("GNU")) == 0) {
> -                               if (read(fd, build_id,
> -                                   BUILD_ID_SIZE) == BUILD_ID_SIZE) {
> +                               size_t sz = min(descsz, size);
> +                               if (read(fd, build_id, sz) == (ssize_t)sz) {
> +                                       memset(build_id + sz, 0, size - sz);
>                                        err = 0;
>                                        break;
>                                }
> -                       } else if (read(fd, bf, descsz) != descsz)
> +                       } else if (read(fd, bf, descsz) != (ssize_t)descsz)
>                                break;
>                } else {
>                        int n = namesz + descsz;
>
���{.n�+�������+%�����ݶ��w��{.n�+����{��G�����{ay�ʇڙ�,j��f���h��������z_�(�階�ݢj"���m������G������?����&���~��iO��z��v�^�m����������?�I�
