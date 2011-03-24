Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933841Ab1CXTOk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Mar 2011 15:14:40 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:59798 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933573Ab1CXTOi convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Mar 2011 15:14:38 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=mpVbEGSzc8FF2BEvMo7HBHBJwzUn9fKGjT8hDHI0N8qDuqYSVvz/9qZLegbDjon2dK
         UOLvFHL0JpmPTQ5N5injJDp2QhZQ0D5mPmfm+SW1ECcYRnN6FuyGRLL+oRoHqISkPmWH
         pOGcMrASiPK1/lt5IhGmcoCY26C6lljXjOMhM=
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.00.1103241404490.5576@router.home>
References: <AANLkTikb8rtSX5hQG6MQF4quymFUuh5Tw97TcpB0YfwS@mail.gmail.com>
	<20110324172653.GA28507@elte.hu>
	<alpine.DEB.2.00.1103241242450.32226@router.home>
	<AANLkTimMcP-GikCCndQppNBsS7y=4beesZ4PaD6yh5y5@mail.gmail.com>
	<alpine.DEB.2.00.1103241300420.32226@router.home>
	<AANLkTi=KZQd-GrXaq4472V3XnEGYqnCheYcgrdPFE0LJ@mail.gmail.com>
	<alpine.DEB.2.00.1103241312280.32226@router.home>
	<1300990853.3747.189.camel@edumazet-laptop>
	<alpine.DEB.2.00.1103241346060.32226@router.home>
	<AANLkTik3rkNvLG-rgiWxKaPc-v9sZQq96ok0CXfAU+r_@mail.gmail.com>
	<20110324185903.GA30510@elte.hu>
	<AANLkTi=66Q-8=AV3Y0K28jZbT3ddCHy9azWedoCC4Nrn@mail.gmail.com>
	<alpine.DEB.2.00.1103241404490.5576@router.home>
Date: Thu, 24 Mar 2011 21:14:37 +0200
X-Google-Sender-Auth: CvA9zERpflLo71q1PSnR4VIYIEA
Message-ID: <AANLkTimWYCHEsZjswLpD-xDcu_cL=GqsMshKRtkHt5Vn@mail.gmail.com>
Subject: Re: [GIT PULL] SLAB changes for v2.6.39-rc1
From: Pekka Enberg <penberg@kernel.org>
To: Christoph Lameter <cl@linux.com>
Cc: Ingo Molnar <mingo@elte.hu>, Eric Dumazet <eric.dumazet@gmail.com>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        tj@kernel.org, npiggin@kernel.dk, rientjes@google.com,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 24, 2011 at 9:05 PM, Christoph Lameter <cl@linux.com> wrote:
> On Thu, 24 Mar 2011, Pekka Enberg wrote:
>
>> It hanged here which is pretty much expected on this box if
>> kmem_cache_init() oopses. I'm now trying to see if I'm able to find
>> the config option that breaks things. CONFIG_PREEMPT_NONE is a
>> suspect:
>>
>> penberg@tiger:~/linux$ grep PREEMPT ../config-ingo
>> # CONFIG_PREEMPT_RCU is not set
>> CONFIG_PREEMPT_NONE=y
>> # CONFIG_PREEMPT_VOLUNTARY is not set
>> # CONFIG_PREEMPT is not set
>
> The following patch should ensure that all percpu data is touched
> before any emulation functions are called:
>
> ---
>  mm/slub.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> Index: linux-2.6/mm/slub.c
> ===================================================================
> --- linux-2.6.orig/mm/slub.c    2011-03-24 14:03:10.000000000 -0500
> +++ linux-2.6/mm/slub.c 2011-03-24 14:04:08.000000000 -0500
> @@ -1604,7 +1604,7 @@ static inline void note_cmpxchg_failure(
>
>  void init_kmem_cache_cpus(struct kmem_cache *s)
>  {
> -#if defined(CONFIG_CMPXCHG_LOCAL) && defined(CONFIG_PREEMPT)
> +#ifdef CONFIG_CMPXCHG_LOCAL
>        int cpu;
>
>        for_each_possible_cpu(cpu)
>

Ingo, can you try this patch out, please? I'm compiling here but
unfortunately I'm stuck with a really slow laptop...
