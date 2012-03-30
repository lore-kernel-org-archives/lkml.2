Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760618Ab2C3KIq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Mar 2012 06:08:46 -0400
Received: from e28smtp08.in.ibm.com ([122.248.162.8]:52131 "EHLO
	e28smtp08.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760399Ab2C3KIi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Mar 2012 06:08:38 -0400
Message-ID: <4F7585EE.7060203@linux.vnet.ibm.com>
Date: Fri, 30 Mar 2012 15:37:42 +0530
From: Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>
Organization: IBM
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.1) Gecko/20120216 Thunderbird/10.0.1
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>
CC: Alan Meadows <alan.meadows@gmail.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Ingo Molnar <mingo@elte.hu>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>,
        the arch/x86 maintainers <x86@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Marcelo Tosatti <mtosatti@redhat.com>, KVM <kvm@vger.kernel.org>,
        Andi Kleen <andi@firstfloor.org>,
        Xen Devel <xen-devel@lists.xensource.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Virtualization <virtualization@lists.linux-foundation.org>,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>,
        Stephan Diestelhorst <stephan.diestelhorst@amd.com>,
        Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        Attilio Rao <attilio.rao@citrix.com>
Subject: Re: [PATCH RFC V6 0/11] Paravirtualized ticketlocks
References: <20120321102041.473.61069.sendpatchset@codeblue.in.ibm.com> <4F707C5F.1000905@redhat.com>	<4F716E31.3000803@linux.vnet.ibm.com> <CAMy5W3foop40+R1RLv_JPhnO5ZmV90uMmNERYY-e3QCeaJfqLw@mail.gmail.com> <4F73568D.7000703@linux.vnet.ibm.com> <4F743247.5080407@redhat.com> <4F74A405.2040609@linux.vnet.ibm.com>
In-Reply-To: <4F74A405.2040609@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
x-cbid: 12033010-2000-0000-0000-000006F7FA71
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/29/2012 11:33 PM, Raghavendra K T wrote:
> On 03/29/2012 03:28 PM, Avi Kivity wrote:
>> On 03/28/2012 08:21 PM, Raghavendra K T wrote:

> I really like below ideas. Thanks for that!.
>
>> - from the PLE handler, don't wake up a vcpu that is sleeping because it
>> is waiting for a kick
>
> How about, adding another pass in the beginning of kvm_vcpu_on_spin()
> to check if any vcpu is already kicked. This would almost result in
> yield_to(kicked_vcpu). IMO this is also worth trying.
>
> will try above ideas soon.
>

I have patch something like below in mind to try:

diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index d3b98b1..5127668 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -1608,15 +1608,18 @@ void kvm_vcpu_on_spin(struct kvm_vcpu *me)
  	 * else and called schedule in __vcpu_run.  Hopefully that
  	 * VCPU is holding the lock that we need and will release it.
  	 * We approximate round-robin by starting at the last boosted VCPU.
+	 * Priority is given to vcpu that are unhalted.
  	 */
-	for (pass = 0; pass < 2 && !yielded; pass++) {
+	for (pass = 0; pass < 3 && !yielded; pass++) {
  		kvm_for_each_vcpu(i, vcpu, kvm) {
  			struct task_struct *task = NULL;
  			struct pid *pid;
-			if (!pass && i < last_boosted_vcpu) {
+			if (!pass && !vcpu->pv_unhalted)
+				continue;
+			else if (pass == 1 && i < last_boosted_vcpu) {
  				i = last_boosted_vcpu;
  				continue;
-			} else if (pass && i > last_boosted_vcpu)
+			} else if (pass == 2 && i > last_boosted_vcpu)
  				break;
  			if (vcpu == me)
  				continue;

