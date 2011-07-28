Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754460Ab1G1ClL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jul 2011 22:41:11 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:52099 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753467Ab1G1ClC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jul 2011 22:41:02 -0400
Message-ID: <4E30CCB4.3080706@cn.fujitsu.com>
Date: Thu, 28 Jul 2011 10:43:00 +0800
From: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110428 Fedora/3.1.10-1.fc15 Thunderbird/3.1.10
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        KVM <kvm@vger.kernel.org>
Subject: Re: [PATCH 11/11] KVM: MMU: improve write flooding detected
References: <4E2EA3DB.7040403@cn.fujitsu.com> <4E2EA5D2.8040804@cn.fujitsu.com> <4E2FD8F7.40303@redhat.com> <4E2FE674.8070202@cn.fujitsu.com> <4E2FF1AA.3020507@redhat.com>
In-Reply-To: <4E2FF1AA.3020507@redhat.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-07-28 10:40:02,
	Serialize by Router on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-07-28 10:40:03,
	Serialize complete at 2011-07-28 10:40:03
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/27/2011 07:08 PM, Avi Kivity wrote:
> On 07/27/2011 01:20 PM, Xiao Guangrong wrote:
>> >>    }
>> >
>> >  I think this is a little dangerous.  A guest kernel may be instantiating multiple gptes on a page fault, but guest userspace hits only one of them (the one which caused the page fault) - I think Windows does this, but I'm not sure.
>> >
>>
>> I think this case is not bad: if the guest kernel need to write multiple gptes (>=3),
>> it will cause many page fault, we do better zap the shadow page and let it become writable as
>> soon as possible.
>> (And, we have pte-fetch, it can quickly establish the mapping for a new shadow page)
> 
> Actually, what should save us is unsync pages.  Why are we hitting this path at all?
> 

Avi,

The shadow page can not became unsync if it has other sp that sp.gfn = gfn && sp.role.level != 1,
for example:
- if the gfn is not only used for the last page structure(PTE page)
or
- gfn was used for upper page structure before but we do not zap the old shadow pages

So, if this gfn is written, #PF is generated, we hope that these sp can be zapped earlier,
the later #PF can detect this gfn is not have shadow pages, and the mapping can became writable.
