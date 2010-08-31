Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756653Ab0HaCXF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Aug 2010 22:23:05 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:63836 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1756585Ab0HaCXD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Aug 2010 22:23:03 -0400
Message-ID: <4C7C687D.2000401@cn.fujitsu.com>
Date: Tue, 31 Aug 2010 10:27:09 +0800
From: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.11) Gecko/20100713 Thunderbird/3.0.6
MIME-Version: 1.0
To: Marcelo Tosatti <mtosatti@redhat.com>
CC: Avi Kivity <avi@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        KVM <kvm@vger.kernel.org>
Subject: Re: [PATCH v2 5/5] KVM: MMU: lower the aduit frequency
References: <4C78FA00.8090606@cn.fujitsu.com> <4C7B867D.9080500@cn.fujitsu.com> <4C7B8759.60900@cn.fujitsu.com> <20100830154719.GB12707@amt.cnet>
In-Reply-To: <20100830154719.GB12707@amt.cnet>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/30/2010 11:47 PM, Marcelo Tosatti wrote:
> On Mon, Aug 30, 2010 at 06:26:33PM +0800, Xiao Guangrong wrote:
>> The audit is very high overhead, so we need lower the frequency to assure the guest running
>>
>> Signed-off-by: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
>> ---
>>  arch/x86/kvm/mmu_audit.c |    7 +++++++
>>  1 files changed, 7 insertions(+), 0 deletions(-)
>>
>> diff --git a/arch/x86/kvm/mmu_audit.c b/arch/x86/kvm/mmu_audit.c
>> index 3bde186..bd2b1be 100644
>> --- a/arch/x86/kvm/mmu_audit.c
>> +++ b/arch/x86/kvm/mmu_audit.c
>> @@ -17,6 +17,8 @@
>>   *
>>   */
>>  
>> +#include <linux/ratelimit.h>
>> +
>>  static const char *audit_msg;
>>  
>>  typedef void (*inspect_spte_fn) (struct kvm_vcpu *vcpu, u64 *sptep, int level);
>> @@ -228,6 +230,11 @@ static void audit_vcpu_spte(struct kvm_vcpu *vcpu)
>>  
>>  static void kvm_mmu_audit(void *ignore, struct kvm_vcpu *vcpu, int audit_point)
>>  {
>> +	static DEFINE_RATELIMIT_STATE(ratelimit_state, 5 * HZ, 10);
>> +
>> +	if (!__ratelimit(&ratelimit_state))
>> +		return;
>> +
>>  	audit_msg = audit_point_name[audit_point];
>>  	audit_all_active_sps(vcpu->kvm);
>>  	audit_vcpu_spte(vcpu);
>> -- 
>> 1.7.0.4
> 
> Well, as Avi said this makes it difficult to trace back to offender (the
> audit points are placed around modifications to the shadow page tree 
> for that reason).
> 

Yeah. it's the best way that not rate limit it, but...

> I've always seen progress from the guest while running with audit
> enabled (its slow, but its not supposed to be fast anyway). 
> 
> Did you experience a freeze? 
> 

There is a simply test in the guest if it's not rate limit:

# time ls
anaconda-ks.cfg  Documents  install.log         Music     Public     Videos
Desktop          Downloads  install.log.syslog  Pictures  Templates

real    1m26.053s
user    0m0.311s
sys     0m1.813s

'ls' command cost about 1.5 minute, if we run the memory test program, i think
the time/delay is unacceptable...... :-(
