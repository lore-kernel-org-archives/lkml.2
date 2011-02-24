Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932462Ab1BXEMi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Feb 2011 23:12:38 -0500
Received: from smtp-out.google.com ([216.239.44.51]:43939 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932383Ab1BXEMh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Feb 2011 23:12:37 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id
         :references:user-agent:mime-version:content-type;
        b=eCJYObS7/GWn5fq+tZyO/mMapFHEP4+8KyjgCgQrtqLbYAdU93Ae72LtHo+sLHms67
         tBOSppc1oTnnXqo3aTWQ==
Date: Wed, 23 Feb 2011 20:12:29 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Mike Travis <travis@sgi.com>
cc: Ingo Molnar <mingo@elte.hu>, Jack Steiner <steiner@sgi.com>,
        Robin Holt <holt@sgi.com>, Len Brown <len.brown@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Yinghai Lu <yhlu.kernel@gmail.com>, linux-acpi@vger.kernel.org,
        x86@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/6] x86: Minimize SRAT messages
In-Reply-To: <4D657AFB.4010501@sgi.com>
Message-ID: <alpine.DEB.2.00.1102232007590.14576@chino.kir.corp.google.com>
References: <20110219024705.308511527@gulag1.americas.sgi.com> <20110219024705.828947738@gulag1.americas.sgi.com> <alpine.DEB.2.00.1102191725150.27722@chino.kir.corp.google.com> <4D657AFB.4010501@sgi.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 23 Feb 2011, Mike Travis wrote:

> [I was finally able to get some time on our large UV test system.]
> 
> Here are the stats testing on a system with 248 nodes, 606 EFI
> mem ranges, 1984 cores
> 
> after get_log_buff_early:  (17% overflow)
> 
>        [    0.000000] early log_buf free: -45723/262183(-17%)
>        [    0.000000] first line: : mem339: type=7, attr=0xf,
> range=[0x00000e6000000000-0x00000e6fff000000) (6552
> 
> Here I enabled some cores that were disabled so now the system
> has 248 nodes, 606 EFI mem ranges, 2368 cores.
> 
> after minimize-time-zero-msgs:  (5% overflow)
> 
> [0] early log_buf free: -15184/262172(-5%)
> [0] first line: [0x000000007226e000-0x0000000072271000) (0MB) <6>[0] EFI:
> mem67: type=3, attr=0
> 
> Condensing the SRAT: PXM APIC messages resulted in 26% space free
> in the early log buffer...
> 
> Was 2368 lines (for 2368 cores):
> 
> 779 [0] SRAT: PXM 0 -> APIC 0x0000 -> Node 0
> 780 [0] SRAT: PXM 0 -> APIC 0x0002 -> Node 0
> 781 [0] SRAT: PXM 0 -> APIC 0x0004 -> Node 0
> ...
> 3145 [0] SRAT: PXM 247 -> APIC 0x3df0 -> Node 247
> 3146 [0] SRAT: PXM 247 -> APIC 0x3df2 -> Node 247
> 

Very cool, if you include these format changes from old to new in the 
individual patch descriptions it would be great.

> Now it's 248 lines (for 248 Nodes) (Nodes 0..191 have 10 core cpus.)
> 
> 777 [0] SRAT: Node 0: PXM:APIC 0:0 :2 :4 :16 :18 :32 :34 :36 :48 :50
> 778 [0] SRAT: Node 1: PXM:APIC 1:64 :66 :68 :80 :82 :96 :98 :100 :112 :114
> 779 [0] SRAT: Node 2: PXM:APIC 2:128 :130 :132 :144 :146 :160 :162 :164 :176
> :178
> ...
> 968 [0] SRAT: Node 190: PXM:APIC 190:12160 :12162 :12164 :12176 :12178 :12192
> :12194 :12196 :12208 :12210
> 969 [0] SRAT: Node 191: PXM:APIC 191:12224 :12226 :12228 :12240 :12242 :12256
> :12258 :12260 :12272 :12274
> ...
> 1023 [0] SRAT: Node 246: PXM:APIC 246:15744 :15746 :15748 :15760 :15778 :15780
> :15792 :15794
> 1024 [0] SRAT: Node 247: PXM:APIC 247:15808 :15810 :15812 :15826 :15840 :15844
> :15856 :15858
> 

Although they look a bit odd, I think these lines are easily parsable and 
understood even without looking at the implementation.

> [0] early log_buf free: 69649/192523(26%)
> [0] first line: <6>[0] Initializing cgroup subsys cpuset <6>[0] Initializing
> cgroup subsys cpu                                       
> My question is is the above decimal satisfactory, or should it be hex as
> shown below?  (Which will add 8k bytes for the "0x" when there are 4096 cores
> but the hex values will be smaller.)
> 
> 821 [0] SRAT: Node 0: PXM:APIC 0:0x0 :0x2 :0x4 :0x10 :0x12 :0x20 :0x22 :0x24
> :0x30 :0x32
> 822 [0] SRAT: Node 1: PXM:APIC 1:0x40 :0x42 :0x44 :0x50 :0x52 :0x60 :0x62
> :0x64 :0x70 :0x72
> 823 [0] SRAT: Node 2: PXM:APIC 2:0x80 :0x82 :0x84 :0x90 :0x92 :0xa0 :0xa2
> :0xa4 :0xb0 :0xb2
> ...
> 1011 [0] SRAT: Node 190: PXM:APIC 190:0x2f80 :0x2f82 :0x2f84 :0x2f90 :0x2f92
> :0x2fa0 :0x2fa2 :0x2fa4 :0x2fb0 :0x2fb2
> 1012 [0] SRAT: Node 191: PXM:APIC 191:0x2fc0 :0x2fc2 :0x2fc4 :0x2fd0 :0x2fd2
> :0x2fe0 :0x2fe2 :0x2fe4 :0x2ff0 :0x2ff2
> ...
> 1067 [0] SRAT: Node 246: PXM:APIC 246:0x3d80 :0x3d82 :0x3d84 :0x3d90 :0x3da2
> :0x3da4 :0x3db0 :0x3db2
> 1068 [0] SRAT: Node 247: PXM:APIC 247:0x3dc0 :0x3dc2 :0x3dc4 :0x3dd2 :0x3de0
> :0x3de4 :0x3df0 :0x3df2
> 
> I will do some more study to see if affecting only these changes will
> be enough to not overflow the early log buffer in a max config system.
> 

I still think we should try to emit the "0x" prefix for any values printed 
in hexadecimal which may or may not be obvious (such as nodes 0 and 1 
above), this is pretty standard.  The final decision would be up to Ingo, 
though.
