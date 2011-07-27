Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752745Ab1G0BqE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jul 2011 21:46:04 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:62721 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751620Ab1G0BqC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jul 2011 21:46:02 -0400
Message-ID: <4E2F6E48.7030802@cn.fujitsu.com>
Date: Wed, 27 Jul 2011 09:47:52 +0800
From: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110428 Fedora/3.1.10-1.fc15 Thunderbird/3.1.10
MIME-Version: 1.0
To: Gleb Natapov <gleb@redhat.com>
CC: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>, KVM <kvm@vger.kernel.org>
Subject: Re: [PATCH 03/11] KVM: x86: fast emulate repeat string write instructions
References: <4E2EA3DB.7040403@cn.fujitsu.com> <4E2EA476.9070607@cn.fujitsu.com> <20110726122710.GM4404@redhat.com>
In-Reply-To: <20110726122710.GM4404@redhat.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-07-27 09:44:57,
	Serialize by Router on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-07-27 09:44:58,
	Serialize complete at 2011-07-27 09:44:58
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/26/2011 08:27 PM, Gleb Natapov wrote:
> On Tue, Jul 26, 2011 at 07:26:46PM +0800, Xiao Guangrong wrote:
>> We usually use repeat string instructions to clear the page, for example,
> By "we" do you mean Linux guest?
> 

I do not know other guests except linux, but, generally rep instruction is
not used to update a page table which is been using.

>> we call memset to clear a page table, stosb is used in this function, and 
>> repeated for 1024 times, that means we should occupy mmu lock for 1024 times
>> and walking shadow page cache for 1024 times, it is terrible
>>
>> In fact, if it is the repeat string instructions emulated and it is not a
>> IO/MMIO access, we can zap all the corresponding shadow pages and return to the
>> guest, then the mapping can became writable and directly write the page
>>


> So this patch does two independent things as far as I can see. First it
> stops reentering guest if rep instruction is done on memory and second

No.
Oppositely, it enters guest as soon as possible if rep instruction is done
on memory ;-)
After this patch, we only need to emulate one time for a rep instruction.

> it drops shadow pages if access to shadowed page table is rep. Why not
> separate those in different patches?  

Umm, i will zap shadow page firstly and stop emulation rep instruction in
the second patch.

> BTW not entering guest periodically
> increases interrupt latencies.

Oppositely, It reduces the latencies. :-)

> Why not zap shadow, make page writable
> and reenter the guest instead of emulation, it should be much faster (do we
> care to optimize for old cpus by complicating the code anyway?).
> 

We do better lazily update the mapping to writable, it can be done by the later access.
