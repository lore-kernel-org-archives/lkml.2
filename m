Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752903Ab0H2JUF (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Aug 2010 05:20:05 -0400
Received: from mx1.redhat.com ([209.132.183.28]:1506 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752524Ab0H2JUD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Aug 2010 05:20:03 -0400
Message-ID: <4C7A263F.1060407@redhat.com>
Date: Sun, 29 Aug 2010 12:19:59 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.8) Gecko/20100806 Fedora/3.1.2-1.fc13 Lightning/1.0b2pre Thunderbird/3.1.2
MIME-Version: 1.0
To: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        KVM <kvm@vger.kernel.org>
Subject: Re: [PATCH 4/4] KVM: MMU: lower the aduit frequency
References: <4C78FA00.8090606@cn.fujitsu.com> <4C78FAF4.4070302@cn.fujitsu.com>
In-Reply-To: <4C78FAF4.4070302@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  On 08/28/2010 03:03 PM, Xiao Guangrong wrote:
> The audit is very high overhead, so we need lower the frequency to assure the guest running
>
>
>    */
>
>   #include<linux/debugfs.h>
> +#include<linux/ratelimit.h>
>
>   static struct dentry *debugfs_file;
>   static bool mmu_debug;
> @@ -233,6 +234,11 @@ static void audit_vcpu_spte(struct kvm_vcpu *vcpu)
>
>   static void kvm_mmu_audit(void *ignore, struct kvm_vcpu *vcpu, const char *msg)
>   {
> +	static DEFINE_RATELIMIT_STATE(ratelimit_state, 5 * HZ, 10);
> +
> +	if (!__ratelimit(&ratelimit_state))
> +		return;
> +
>   	audit_msg = msg;
>   	audit_all_active_sps(vcpu->kvm);
>   	audit_vcpu_spte(vcpu);

This means we see a bug long after it happened, so we can't correlate it 
to the cause.

It's fine as an option (even the default) but I'd like to be able to 
audit after every operation.  Perhaps a partial audit that only looks at 
the gfns and vaddrs that were affected in the last operation?

I have to admit, it's been a very long time since I last used audit.

-- 
error compiling committee.c: too many arguments to function

