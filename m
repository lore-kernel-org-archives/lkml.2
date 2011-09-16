Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754898Ab1IPQez (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Sep 2011 12:34:55 -0400
Received: from smtp-out.google.com ([216.239.44.51]:41837 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750755Ab1IPQey convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Sep 2011 12:34:54 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=dkim-signature:mime-version:in-reply-to:references:date:
	message-id:subject:from:to:cc:content-type:
	content-transfer-encoding:x-system-of-record;
	b=PeyilVrhAeBxIhnbGyCuVAQnWkj0LVIaAPCDqe/SSHLYJaXsfp0yaoaRWiCSch0SJ
	1F24z5k4u1pTbfQiP8teQ==
MIME-Version: 1.0
In-Reply-To: <4E736C5A.1040502@gmail.com>
References: <20110907191045.GA13475@quad>
	<4E6E0D0B.3080306@gmail.com>
	<CABPqkBSfQo5E=MJ913E--dc8Fi7VLcFSGNbBf60tOnTLMuVN_w@mail.gmail.com>
	<4E6E181E.9080506@gmail.com>
	<CABPqkBQWd=DyRRDhaxwDGrpCs=XqyTUv72+dn7GKsT=kjPqiJg@mail.gmail.com>
	<1315838611.26517.51.camel@twins>
	<CABPqkBShe6OG1ukQ=7vn_Mr=Aa_c8jcbo1mYuF+41Euy5_R7Dw@mail.gmail.com>
	<4E73622D.5010506@gmail.com>
	<1316186353.10174.29.camel@twins>
	<4E736C5A.1040502@gmail.com>
Date: Fri, 16 Sep 2011 18:34:50 +0200
Message-ID: <CABPqkBR66vzNz7+MxtFk_zmpBTFqAX83he7kGB2+HALK9xbkWQ@mail.gmail.com>
Subject: Re: [PATCH] perf: make perf.data more self-descriptive (v4)
From: Stephane Eranian <eranian@google.com>
To: David Ahern <dsahern@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
        acme@redhat.com, mingo@elte.hu
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 16, 2011 at 5:33 PM, David Ahern <dsahern@gmail.com> wrote:
>
>
> On 09/16/2011 09:19 AM, Peter Zijlstra wrote:
>> On Fri, 2011-09-16 at 08:50 -0600, David Ahern wrote:
>>>
>>> ppc data file: header->magic 454c494646524550
>>> x86 data file: header->magic 454c494646524550
>>>
>> Ok then we need to fix that magic thing..
>
> Right, but it breaks backwards/forwards compatibility. e.g.,
>
Not necessarily, if you keep the current MAGIC, then you detect
a file with the old format, i.e., no flexibility on attr_size.

Then, you pick two new MAGIC numbers. They must, of course,
reflect the endianness. Those new perf.data files won't work with
older perf for sure, but at least you can maintain backward
compatibility. The new MAGIC must, of course, reflect the
endianness.



> diff --git a/tools/perf/util/header.c b/tools/perf/util/header.c
> index 73fa59e..603a8bb9 100644
> --- a/tools/perf/util/header.c
> +++ b/tools/perf/util/header.c
> @@ -65,9 +65,7 @@ char *perf_header__find_event(u64 id)
>    return NULL;
>  }
>
> -static const char *__perf_magic = "PERFFILE";
> -
> -#define PERF_MAGIC (*(u64 *)__perf_magic)
> +#define PERF_MAGIC 0x5045524646494c45ULL  // "PERFFILE"
>
>  struct perf_file_attr {
>    struct perf_event_attr  attr;
>
> That puts the magic in the file based on endianness of the recording
> system. e.g., on x86:
>
> $ od -c perf-magic.data | head -1
> 0000000   E   L   I   F   F   R   E   P   h  \0  \0  \0  \0  \0  \0  \0
>
> Which means older perf binaries can't analyze new files (created with
> new magic order) and newer perf binaries can't analyze older perf files
> -- the new command will incorrectly want to do endian swapping on the
> old file.
>
> David
>
