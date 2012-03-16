Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754749Ab2CPShA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Mar 2012 14:37:00 -0400
Received: from mga06.intel.com ([134.134.136.21]:15416 "EHLO
	orsmga101.jf.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754507Ab2CPSg6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Mar 2012 14:36:58 -0400
Subject: Re: [tip:x86/urgent] x86, efi: Delete efi_ioremap() and fix
 CONFIG_X86_32 oops
From: Matt Fleming <matt.fleming@intel.com>
To: Yinghai Lu <yinghai@kernel.org>
Cc: "H. Peter Anvin" <hpa@kernel.org>, mingo@redhat.com, mjg@redhat.com,
        linux-kernel@vger.kernel.org, keithp@keithp.com, rui.zhang@intel.com,
        huang.ying.caritas@gmail.com, stable@vger.kernel.org,
        tglx@linutronix.de, linux-tip-commits@vger.kernel.org
In-Reply-To: <CAE9FiQVWjZFA9gz43NJAKbvp7HT0oekXiRY5mPgg6O8EN5xb7g@mail.gmail.com>
References: <1329744626-5036-1-git-send-email-matt@console-pimps.org>
	 <tip-f75bd1837564657b21431e44243e064a77276589@git.kernel.org>
	 <CAE9FiQWFpsZotawqPD4738jTayB=KOGo0W9+AT2go3GYk1v_sQ@mail.gmail.com>
	 <4F45B35D.1010702@zytor.com>
	 <CAE9FiQUbyYYN5orG_RyVm=P-8wNh=YsET1VzGojpFTfJPueHqA@mail.gmail.com>
	 <4F471651.3080609@zytor.com> <4F4C3BA2.1070708@kernel.org>
	 <1331116250.3539.35.camel@mfleming-mobl1.ger.corp.intel.com>
	 <CAE9FiQUoRMA_PYnOEt0ZUYXLq=hNZtDuLifT=+R72HtrwfF6AA@mail.gmail.com>
	 <1331206127.3539.69.camel@mfleming-mobl1.ger.corp.intel.com>
	 <CAE9FiQVZVNARgs0rzgRpRdbSPydCXoeDat=4DLMNFcyBQuqwng@mail.gmail.com>
	 <1331555916.3539.88.camel@mfleming-mobl1.ger.corp.intel.com>
	 <CAE9FiQXA4+Ubh-6QZv5bouZchR6XZjBSGwR1ox-vug01xiGveA@mail.gmail.com>
	 <1331815251.15493.108.camel@mfleming-mobl1.ger.corp.intel.com>
	 <CAE9FiQVWjZFA9gz43NJAKbvp7HT0oekXiRY5mPgg6O8EN5xb7g@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Organization: Intel Corporation (UK) Ltd. - Registered No. 1134945 - Pipers
 Way, Swindon SN3 1RJ
Date: Fri, 16 Mar 2012 18:36:46 +0000
Message-ID: <1331923006.4041.30.camel@mfleming-mobl1.ger.corp.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 (2.32.3-1.fc14)
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-03-15 at 10:54 -0700, Yinghai Lu wrote:
> >                if (end <= max_low_pfn << PAGE_SHIFT)
> >                        max_low_pfn_mapped = last_pfn_mapped;
> 
> why max_low_pfn is used here?

The idea is that we only want to update max_low_pfn_mapped when we've
mapped a region at or below max_low_pfn. This maintains compatibility
with behaviour prior to this patch.

> > The max_low_pfn checks are only for CONFIG_X86_32 so that the behaviour
> > is the same as before this patch, i.e. we don't try to map above
> > max_low_pfn.
> 
> ok, to simplify the code, in setup.c you could move
> #ifdef CONFIG_X86_64
>         if (max_pfn > max_low_pfn) {
>                 /* can we preseve max_low_pfn ?*/
>                 max_low_pfn = max_pfn;
>         }
> #endif
> 
> before calling new init_memory_mapping()...
> 
> so you could remove the #idef. in init_memory_mapping.

Hmm.. if we do this then max_low_pfn_mapped will be set to max_pfn on
CONFIG_X86_64 by the time we've finished looping in
init_memory_mapping(). This is not how things work currently. Will that
cause a problem?

