Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754255Ab1G0KIj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jul 2011 06:08:39 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:51913 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1750982Ab1G0KIe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jul 2011 06:08:34 -0400
Message-ID: <4E2FE419.2010800@cn.fujitsu.com>
Date: Wed, 27 Jul 2011 18:10:33 +0800
From: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110428 Fedora/3.1.10-1.fc15 Thunderbird/3.1.10
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        KVM <kvm@vger.kernel.org>
Subject: Re: [PATCH 10/11] KVM: MMU: fix detecting misaligned accessed
References: <4E2EA3DB.7040403@cn.fujitsu.com> <4E2EA5AA.2010708@cn.fujitsu.com> <4E2FD731.7010206@redhat.com>
In-Reply-To: <4E2FD731.7010206@redhat.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-07-27 18:07:37,
	Serialize by Router on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-07-27 18:07:38,
	Serialize complete at 2011-07-27 18:07:38
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/27/2011 05:15 PM, Avi Kivity wrote:
> On 07/26/2011 02:31 PM, Xiao Guangrong wrote:
>> Sometimes, we only modify the last one byte of a pte to update status bit,
>> for example, clear_bit is used to clear r/w bit in linux kernel and 'andb'
>> instruction is used in this function, in this case, kvm_mmu_pte_write will
>> treat it as misaligned access, and the shadow page table is zapped
>>
>> @@ -3597,6 +3597,14 @@ static bool detect_write_misaligned(struct kvm_mmu_page *sp, gpa_t gpa,
>>
>>       offset = offset_in_page(gpa);
>>       pte_size = sp->role.cr4_pae ? 8 : 4;
>> +
>> +    /*
>> +     * Sometimes, the OS only writes the last one bytes to update status
>> +     * bits, for example, in linux, andb instruction is used in clear_bit().
>> +     */
>> +    if (sp->role.level == 1&&  !(offset&  (pte_size - 1))&&  bytes == 1)
>> +        return false;
>> +
> 
> Could be true for level > 1, no?
> 

In my origin mind, i thought one-byte-instruction is usually used to update the last pte,
but we do better remove this restriction. Will fix it in the next version, thanks!
