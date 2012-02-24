Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757252Ab2BXLdW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Feb 2012 06:33:22 -0500
Received: from e33.co.us.ibm.com ([32.97.110.151]:38970 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752304Ab2BXLdU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Feb 2012 06:33:20 -0500
Message-ID: <4F47756F.1020602@linux.vnet.ibm.com>
Date: Fri, 24 Feb 2012 17:03:03 +0530
From: Prashanth Nageshappa <prashanth@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0) Gecko/20120131 Thunderbird/10.0
MIME-Version: 1.0
To: acme@infradead.org
CC: ananth@in.ibm.com, akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
        jbaron@redhat.com, rostedt@goodmis.org, srikar@linux.vnet.ibm.com,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Subject: Re: [PATCH] perf - ensure offset provided during probe addition is
 not greater than function length
References: <4F45FABE.90104@linux.vnet.ibm.com> <4F473F33.4060409@linux.vnet.ibm.com> <4F47673B.6000103@hitachi.com>
In-Reply-To: <4F47673B.6000103@hitachi.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12022411-2398-0000-0000-00000480393B
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Can you please pick up this patch?

On 02/24/2012 04:02 PM, Masami Hiramatsu wrote:

> (2012/02/24 16:41), Prashanth Nageshappa wrote:
>> perf probe allows kprobe to be inserted at any offset from a function
>> start, which results in adding kprobes to unintended location.
>> (example: perf probe do_fork+10000 is allowed even though size of
>> do_fork is ~904)
>>
>> This patch will ensure probe addition fails when the offset specified
>> is greater than size of the function.
>>
>>
>> Signed-off-by: Prashanth Nageshappa <prashanth@linux.vnet.ibm.com>
> 
> This seems good to me.
> 
> Acked-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
> 
> Thank you,
> 
>> ---
>>
>>  tools/perf/util/probe-finder.c |   12 +++++++++++-
>>  1 files changed, 11 insertions(+), 1 deletions(-)
>>
>> diff --git a/tools/perf/util/probe-finder.c b/tools/perf/util/probe-finder.c
>> index 5d73262..d298f94 100644
>> --- a/tools/perf/util/probe-finder.c
>> +++ b/tools/perf/util/probe-finder.c
>> @@ -672,7 +672,7 @@ static int find_variable(Dwarf_Die *sc_die, struct probe_finder *pf)
>>  static int convert_to_trace_point(Dwarf_Die *sp_die, Dwarf_Addr paddr,
>>  				  bool retprobe, struct probe_trace_point *tp)
>>  {
>> -	Dwarf_Addr eaddr;
>> +	Dwarf_Addr eaddr, highaddr;
>>  	const char *name;
>>
>>  	/* Copy the name of probe point */
>> @@ -683,6 +683,16 @@ static int convert_to_trace_point(Dwarf_Die *sp_die, Dwarf_Addr paddr,
>>  				   dwarf_diename(sp_die));
>>  			return -ENOENT;
>>  		}
>> +		if (dwarf_highpc(sp_die, &highaddr) != 0) {
>> +			pr_warning("Failed to get end address of %s\n",
>> +				   dwarf_diename(sp_die));
>> +			return -ENOENT;
>> +		}
>> +		if (paddr > highaddr) {
>> +			pr_warning("Offset specified is greater than size of %s\n",
>> +				   dwarf_diename(sp_die));
>> +			return -EINVAL;
>> +		}
>>  		tp->symbol = strdup(name);
>>  		if (tp->symbol == NULL)
>>  			return -ENOMEM;
>>
> 
> 


