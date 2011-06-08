Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754065Ab1FHTKF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jun 2011 15:10:05 -0400
Received: from mail-vx0-f174.google.com ([209.85.220.174]:63546 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753703Ab1FHTKD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jun 2011 15:10:03 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=M+SIv4Nx2mBDmKwYBwA+5/0KCyQBz7YG2sWbLbfnwk5lpMbIswsMubbV24Jl45uJ8A
         Rr0H2ogZAVMqfMvWRx5SwjZraRKB5QFLsiVTEVpfiP1asU8SoKhOE+idCGP8OqsUrkbb
         33k7tFCh2q/F+8IUNTZauBFq/pdQ5dK2ZELus=
MIME-Version: 1.0
In-Reply-To: <4DEFC6DA.9050809@cuw.edu>
References: <1307503774-30370-1-git-send-email-Gregory.Dietsche@cuw.edu>
	<1307503774-30370-2-git-send-email-Gregory.Dietsche@cuw.edu>
	<4DEFC6DA.9050809@cuw.edu>
Date: Wed, 8 Jun 2011 21:10:00 +0200
X-Google-Sender-Auth: bpx8zdMtzTRs2Xe6aHdHPIE0Xs4
Message-ID: <BANLkTi=gZzsZcSKUd3x50PbPwKC-Vnj24Q@mail.gmail.com>
Subject: Re: [PATCH 1/2] coccicheck: add M= option to control which dir is processed
From: Nicolas Palix <Nicolas.Palix@inria.fr>
To: Greg Dietsche <gregory.dietsche@cuw.edu>
Cc: julia@diku.dk, rdunlap@xenotime.net, Gilles.Muller@lip6.fr, cocci@diku.dk,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Wed, Jun 8, 2011 at 9:00 PM, Greg Dietsche <gregory.dietsche@cuw.edu> wrote:
>
>
> On 06/07/2011 10:29 PM, Greg Dietsche wrote:
>>
>> Examples:
>>        make coccicheck M=drivers/net/wireless/
>>        make coccicheck SUBDIRS=drivers/net/wireless/
>>
>> Signed-off-by: Greg Dietsche<Gregory.Dietsche@cuw.edu>
>> ---
>>  scripts/coccicheck |   13 +++++++++++--
>>  1 files changed, 11 insertions(+), 2 deletions(-)
>>
>> diff --git a/scripts/coccicheck b/scripts/coccicheck
>> index 1bb1a1b..6f08efa 100755
>> --- a/scripts/coccicheck
>> +++ b/scripts/coccicheck
>> @@ -10,13 +10,22 @@ if [ "$C" = "1" -o "$C" = "2" ]; then
>>  #    OPTIONS=$*
>>
>>  # Workaround for Coccinelle<  0.2.3
>> -    FLAGS="-I $srctree/include -very_quiet"
>> +    if [ "$KBUILD_EXTMOD" = "" ] ; then
>> +        FLAGS="-I $srctree/include -very_quiet"
>> +    else
>> +           echo 'M= is only supported for Coccinelle>= 0.2.3'
>> +           exit 1
>> +    fi
>>      shift $(( $# - 1 ))
>>      OPTIONS=$1
>>  else
>>      ONLINE=0
>>      FLAGS="-very_quiet"
>> -    OPTIONS="-dir $srctree"
>> +    if [ "$KBUILD_EXTMOD" = "" ] ; then
>> +        OPTIONS="-dir $srctree"
>> +    else
>> +        OPTIONS="-dir $KBUILD_EXTMOD"
>>
>
> So far I've found one bug after reading Nicolas's comments on the other
> thread. In order to have the diffs print file names correctly, I definitely
> need to update my patch to do this:
>
> +        OPTIONS="-dir $KBUILD_EXTMOD -patch $srctree"
>
> Also, do I need to tell cocci where the includes are? Based on my somewhat
> limited knowledge and testing, I'm not sure... but so far the tests seem to
> work without it. If we really do need to tell it about the includes, then
> the line should read:
>
> +        OPTIONS="-dir $KBUILD_EXTMOD -patch $srctree -I $srctree/include"

I am not familiar with out-of-tree development but I guess that in
that case we should
also add a "-I $KBUILD_EXTMOD/include" ?

The use of -I by Coccinelle depends on the other options (like
-include_headers or -all_includes).
Such options are retrieved from the comments in the cocci files.
So the need for -I depends on the semantic patch you consider. I think
it is thus better
to be "exhaustive" in that case.

Julia, is there any performance problem in doing so ?


>
>
>
>> +    fi
>>  fi
>>
>>  if [ ! -x "$SPATCH" ]; then
>>
>
> Greg
>
>



-- 
Nicolas Palix
http://sardes.inrialpes.fr/~npalix/
