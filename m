Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754299Ab2FZV7S (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jun 2012 17:59:18 -0400
Received: from nm3-vm0.access.bullet.mail.sp2.yahoo.com ([98.139.44.108]:28471
	"HELO nm3-vm0.access.bullet.mail.sp2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753512Ab2FZV7P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jun 2012 17:59:15 -0400
X-Yahoo-Newman-Id: 155679.66442.bm@omp1019.access.mail.sp2.yahoo.com
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: ylpXDhMVM1krH_cNycUwuNdiYulgFZbYzQE18tGBmZzMADt
 IWFFF7ylHqKuy4jhTI_WUiFWRiNReE2NoQouVlp16ePoHET0sNsg6jmmGjSj
 5ODfoooIyItTlC5D06iXZvPF0XoSc_1C8Hc00KpL7WLtT19W6MjC_CirPZ8M
 S8kPuU6IJIsQJlSOkQEbd8sPmXe0ZCdwou3rHoJEwMM0KJOcMZQsw5W1O05z
 5ngsTg5DpOzLWgHHLbtJ.YCzvXa8t.t9.mrk.zg5oTjSPLVpXGiJT1QrX7dd
 o.6fqH8fzuNHjypkm5O.8uwP6.VT3.kTMfOhYwOD2MO5Hj5dPrmtISiXeHsw
 MXawHIjjxWt0ZEXpGSggR74z2proCNPCYVXOWDkSe7gB4xu0fGX5M36wOGz4
 A30MbMQ--
X-Yahoo-SMTP: xXkkXk6swBBAi.5wfkIWFW3ugxbrqyhyk_b4Z25Sfu.XGQ--
Message-ID: <4FEA30B2.9010902@att.net>
Date: Tue, 26 Jun 2012 16:59:14 -0500
From: Daniel Santos <danielfsantos@att.net>
Reply-To: Daniel Santos <daniel.santos@pobox.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.4) Gecko/20120502 Thunderbird/10.0.4
MIME-Version: 1.0
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
CC: Andrew Morton <akpm@linux-foundation.org>,
        Christopher Li <sparse@chrisli.org>,
        David Daney <david.daney@cavium.com>,
        David Howells <dhowells@redhat.com>,
        David Rientjes <rientjes@google.com>,
        Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
        Ingo Molnar <mingo@kernel.org>, Joe Perches <joe@perches.com>,
        Konstantin Khlebnikov <khlebnikov@openvz.org>,
        linux-doc@vger.kernel.org, linux-sparse@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Paul Turner <pjt@google.com>, Pavel Pisa <pisa@cmp.felk.cvut.cz>,
        Richard Weinberger <richard@nod.at>, Rob Landley <rob@landley.net>,
        Steven Rostedt <rostedt@goodmis.org>,
        Suresh Siddha <suresh.b.siddha@intel.com>
Subject: Re: [PATCH v4 12/13] fair.c: Use generic rbtree impl in fair scheduler
References: <1340424048-7759-1-git-send-email-daniel.santos@pobox.com> <1340424048-7759-13-git-send-email-daniel.santos@pobox.com> <1340712949.21991.57.camel@twins>
In-Reply-To: <1340712949.21991.57.camel@twins>
X-Enigmail-Version: 1.3.5
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/26/2012 07:15 AM, Peter Zijlstra wrote:
> On Fri, 2012-06-22 at 23:00 -0500, Daniel Santos wrote:
>> +static inline long compare_vruntime(u64 *a, u64 *b)
>> +{
>> +#if __BITS_PER_LONG >= 64
>> +       return (long)((s64)*a - (s64)*b);
>> +#else
>> +/* This is hacky, but is done to reduce instructions -- we wont use this for
>> + * rbtree lookups, only inserts, and since our relationship is defined as
>> + * non-unique, we only need to return positive if a > b and any other value
>> + * means less than.
>> + */
>> +       return (long)(*a > *b);
>> +#endif
>> +} 
> That's wrong.. suppose: a = 10, b = ULLONG_MAX - 10
>
> In that case (s64)(a - b) = 20, however a > b is false.
>
> And yes, vruntime wrap does happen.
Oh, I see now! (looking at entity_before)

static inline int entity_before(struct sched_entity *a,
                                struct sched_entity *b)
{
        return (s64)(a->vruntime - b->vruntime) < 0;
}

Do the subtraction unsigned, then evaluate the result as signed.  Thank
you very much, I'll fix that.

Also, to address why we're not using entity_before (or a less()
function) directly, there's two main reasons (one that doesn't even
affect CFS).  The first reason is that an "is equal" evaluation would
also be required for insertions in trees with unique keys, as well as
all lookups.  This doesn't doesn't affect CFS because it isn't doing
lookups (it only cares about leftmost) and duplicate keys are allowed.

The second is that the compare function is only evaluated once by just
returning a diff.  This *would* have an better performance benefit on
x86 if only gcc were willing to do the cmp or sub operation and then use
the CPU zero & negative flags to branch.  Instead, it seems to like to
do a sub (to subtract the values) and then cmp the result with zero. 
This is only once extra instruction in this case, but when you need to
use the (a > b ? 1 : (a < b ? -1 : 0)) construct, it's worse.  Off
topic, but something I wanted to mention in light of my "this is hacky"
section.

I guess I just need "get off of my duff", put together a succinct test
case and file a gcc bug report for this.

Daniel

