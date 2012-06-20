Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758072Ab2FTUNw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2012 16:13:52 -0400
Received: from e23smtp04.au.ibm.com ([202.81.31.146]:40820 "EHLO
	e23smtp04.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754452Ab2FTUNu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2012 16:13:50 -0400
Message-ID: <4FE22E9E.7070206@linux.vnet.ibm.com>
Date: Thu, 21 Jun 2012 01:42:14 +0530
From: Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>
Organization: IBM
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.1) Gecko/20120216 Thunderbird/10.0.1
MIME-Version: 1.0
To: Rik van Riel <riel@redhat.com>
CC: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>,
        Srikar <srikar@linux.vnet.ibm.com>,
        Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
        Peter Zijlstra <peterz@infradead.org>,
        "Nikunj A. Dadhania" <nikunj@linux.vnet.ibm.com>,
        KVM <kvm@vger.kernel.org>, Ingo Molnar <mingo@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] kvm: handle last_boosted_vcpu = 0 case
References: <20120619202047.26191.40429.sendpatchset@codeblue> <20120619165104.2a4574f8@annuminas.surriel.com>
In-Reply-To: <20120619165104.2a4574f8@annuminas.surriel.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
x-cbid: 12062009-9264-0000-0000-000001BCE055
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/20/2012 02:21 AM, Rik van Riel wrote:
> On Wed, 20 Jun 2012 01:50:50 +0530
> Raghavendra K T<raghavendra.kt@linux.vnet.ibm.com>  wrote:
>
>>
>> In ple handler code, last_boosted_vcpu (lbv) variable is
>> serving as reference point to start when we enter.
>
>> Also statistical analysis (below) is showing lbv is not very well
>> distributed with current approach.
>
> You are the second person to spot this bug today (yes, today).

Oh! really interesting.

>
> Due to time zones, the first person has not had a chance yet to
> test the patch below, which might fix the issue...

May be his timezone also falls near to mine. I am also pretty late
now. :)

>
> Please let me know how it goes.

Yes, have got result today, too tired to summarize. got better
performance result too. will come back again tomorrow morning.
have to post, randomized start point patch also, which I discussed to
know the opinion.

>
> ====8<====
>
> If last_boosted_vcpu == 0, then we fall through all test cases and
> may end up with all VCPUs pouncing on vcpu 0.  With a large enough
> guest, this can result in enormous runqueue lock contention, which
> can prevent vcpu0 from running, leading to a livelock.
>
> Changing<  to<= makes sure we properly handle that case.

Analysis shows distribution is more flatten now than before.
Here are the snapshots:
snapshot1
PLE handler yield stat :
66447   132222  75510   65875   121298  92543  111267  79523
118134  105366  116441  114195  107493  66666  86779   87733
84415   105778  94210   73197   55626   93036  112959  92035
95742   78558   72190   101719  94667   108593 63832   81580

PLE handler start stat :
334301  687807  384077  344917  504917  343988  439810  371389
466908  415509  394304  484276  376510  292821  370478  363727
366989  423441  392949  309706  292115  437900  413763  346135
364181  323031  348405  399593  336714  373995  302301  347383


snapshot2
PLE handler yield stat :
320547  267528  264316  164213  249246  182014  246468  225386
277179  310659  349767  310281  238680  187645  225791  266290
216202  316974  231077  216586  151679  356863  266031  213047
306229  182629  229334  241204  275975  265086  282218  242207

PLE handler start stat :
1335370  1378184  1252001  925414   1196973  951298   1219835  1108788
1265427  1290362  1308553  1271066  1107575  980036   1077210  1278611
1110779  1365130  1151200  1049859  937159   1577830  1209099  993391
1173766  987307   1144775  1102960  1100082  1177134  1207862  1119551


>
> Signed-off-by: Rik van Riel<riel@redhat.com>
> ---
>   virt/kvm/kvm_main.c |    2 +-
>   1 files changed, 1 insertions(+), 1 deletions(-)
>
> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> index 7e14068..1da542b 100644
> --- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c
> @@ -1586,7 +1586,7 @@ void kvm_vcpu_on_spin(struct kvm_vcpu *me)
>   	 */
>   	for (pass = 0; pass<  2&&  !yielded; pass++) {
>   		kvm_for_each_vcpu(i, vcpu, kvm) {
> -			if (!pass&&  i<  last_boosted_vcpu) {
> +			if (!pass&&  i<= last_boosted_vcpu) {

Hmmm true, great catch. it was partial towards zero earlier.

>   				i = last_boosted_vcpu;
>   				continue;
>   			} else if (pass&&  i>  last_boosted_vcpu)
>
>

