Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758321Ab0CaWlX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Mar 2010 18:41:23 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:38539 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755213Ab0CaWlW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Mar 2010 18:41:22 -0400
Date: Thu, 1 Apr 2010 00:41:08 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Yinghai Lu <yinghai@kernel.org>
Cc: James Morris <jmorris@namei.org>, "H. Peter Anvin" <hpa@zytor.com>,
       linux-kernel@vger.kernel.org, airlied@linux.ie
Subject: Re: Config NO_BOOTMEM breaks my amd64 box
Message-ID: <20100331224108.GA11284@elte.hu>
References: <alpine.LRH.2.00.1003311539490.23281@tundra.namei.org>
 <4BB2EB1B.8090303@zytor.com>
 <alpine.LRH.2.00.1003311747040.23859@tundra.namei.org>
 <4BB3C739.2020106@kernel.org>
 <20100331221341.GA20441@elte.hu>
 <4BB3C9B0.4000205@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4BB3C9B0.4000205@kernel.org>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: 0.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=0.0 required=5.9 tests=none autolearn=no SpamAssassin version=3.2.5
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Yinghai Lu <yinghai@kernel.org> wrote:

> On 03/31/2010 03:13 PM, Ingo Molnar wrote:
> > 
> > * Yinghai Lu <yinghai@kernel.org> wrote:
> > 
> >> --- linux-2.6.orig/arch/x86/mm/init_32.c
> >> +++ linux-2.6/arch/x86/mm/init_32.c
> >> @@ -875,7 +875,12 @@ void __init mem_init(void)
> >>  	BUG_ON(!mem_map);
> >>  #endif
> >>  	/* this will put all low memory onto the freelists */
> >> +#if defined(CONFIG_NO_BOOTMEM) && defined(MAX_NUMNODES)
> >> +	/* In case some 32bit systems don't have RAM installed on node0 */
> >> +        totalram_pages += free_all_memory_core_early(MAX_NUMNODES);
> > 
> > (Note: tab whitespace damage)
> > 
> >> +#else
> >>  	totalram_pages += free_all_bootmem();
> > 
> > So we get into this branch if CONFIG_NO_BOOTMEM is enabled but MAX_NUMNODES is 
> > not defined? Doesnt look right.
> 
> yes. 
> 
> free_all_bootmem() will call
> free_all_memory_core_early(NODE_DATA(0)->node_id);
> 
> Thanks

Well and that whole #ifdeffery is disgusting as well - even if the goal was to 
remove CONFIG_NO_BOOTMEM ASAP.

Please learn to use proper intermediate helper functions and at minimum put 
the conversion ugliness somewhere that doesnt intrude our daily flow in .c 
files. The best rule is to _never ever_ put an #ifdef construct into a .c 
file. It doesnt matter what the goal if the #ifdef is - such ugliness in code 
is never justified.

Thanks,

	Ingo
