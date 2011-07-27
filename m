Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754376Ab1G0KCJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jul 2011 06:02:09 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:61375 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752252Ab1G0KCG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jul 2011 06:02:06 -0400
Message-ID: <4E2FE295.5070905@cn.fujitsu.com>
Date: Wed, 27 Jul 2011 18:04:05 +0800
From: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110428 Fedora/3.1.10-1.fc15 Thunderbird/3.1.10
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        KVM <kvm@vger.kernel.org>
Subject: Re: [PATCH 04/11] KVM: MMU: do not mark access bit on pte write path
References: <4E2EA3DB.7040403@cn.fujitsu.com> <4E2EA4C8.5010103@cn.fujitsu.com> <4E2FD578.2090803@redhat.com>
In-Reply-To: <4E2FD578.2090803@redhat.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-07-27 18:01:10,
	Serialize by Router on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-07-27 18:01:10,
	Serialize complete at 2011-07-27 18:01:10
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/27/2011 05:08 PM, Avi Kivity wrote:
> On 07/26/2011 02:28 PM, Xiao Guangrong wrote:
>> In current code, the accessed bit is always set when page fault occurred,
>> do not need to set it on pte write path
>>
> 
> Is this true? a write with pte.w=pte.a=0 sets pte.a?
> 

Generally, we will call set_spte() with speculative = false, then Accessed bit
is set on page fault path, but there has two case:
- if pte.d = 1, everything is ok
- if pte.d = 0, so this write can change pte.d = 1, the access permission of
  shadow page can be changed from read-only to writable. So, we will find a
  new sp to establish the mapping. In this case, the original spte is not
  set Accessed bit.

However, we used Accessed bit to detect write flooding, so the first write can
set the dirty bit, and the later write can not cause sp changed. I think it is
not too bad.
