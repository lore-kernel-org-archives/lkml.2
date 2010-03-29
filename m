Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754017Ab0C2VWy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Mar 2010 17:22:54 -0400
Received: from mx1.redhat.com ([209.132.183.28]:37913 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753250Ab0C2VWw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Mar 2010 17:22:52 -0400
Message-ID: <4BB119F8.7020206@redhat.com>
Date: Mon, 29 Mar 2010 17:22:00 -0400
From: Masami Hiramatsu <mhiramat@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.8) Gecko/20100301 Fedora/3.0.3-1.fc11 Thunderbird/3.0.3
MIME-Version: 1.0
To: Arnaldo Carvalho de Melo <acme@infradead.org>
CC: Ingo Molnar <mingo@elte.hu>, lkml <linux-kernel@vger.kernel.org>,
       systemtap <systemtap@sources.redhat.com>,
       DLE <dle-develop@lists.sourceforge.net>,
       Paul Mackerras <paulus@samba.org>,
       Peter Zijlstra <peterz@infradead.org>, Mike Galbraith <efault@gmx.de>,
       Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: [PATCH -tip 5/7] perf probe: Query basic types from debuginfo
References: <20100329203736.2577.56018.stgit@localhost6.localdomain6> <20100329203829.2577.44718.stgit@localhost6.localdomain6> <20100329205143.GQ3625@ghostprotocols.net>
In-Reply-To: <20100329205143.GQ3625@ghostprotocols.net>
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Arnaldo Carvalho de Melo wrote:
> Em Mon, Mar 29, 2010 at 04:38:29PM -0400, Masami Hiramatsu escreveu:
>> +static void convert_variable_type(Dwarf_Die *vr_die,
>> +				  struct kprobe_trace_arg *targ)
>> +{
>> +	Dwarf_Die type;
>> +	char buf[16];
>> +	int ret;
>> +
>> +	if (die_get_real_type(vr_die, &type) == NULL)
>> +		die("Failed to get a type information of %s.",
>> +		    dwarf_diename(vr_die));
>> +
>> +	ret = die_get_byte_size(&type) * 8;
>> +	if (ret) {
>> +		/* Check the bitwidth */
>> +		if (ret > MAX_BASIC_TYPE_BITS) {
>> +			pr_warning("  Warning: %s exceeds max-bitwidth."
>> +				   " Cut down to %d bits.\n",
>> +				   dwarf_diename(&type), MAX_BASIC_TYPE_BITS);
>> +			ret = MAX_BASIC_TYPE_BITS;
>> +		}
>> +
>> +		ret = snprintf(buf, 16, "%c%d",
>> +			       die_is_signed_type(&type) ? 's' : 'u', ret);
>> +		if (ret < 0 || ret >= 16)
>> +			die("Failed to convert variable type.");
>> +		targ->type = xstrdup(buf);
> 
> Question, should we use the equivalent to panic'ing the kernel in the
> userspace bits in tools/?
> 
> I tend to see all code there as potentially part of a library, i.e. to
> be callable by some unantecipated new tool or library that would rather
> receive a return value telling it that the operation can't be performed
> for some reason so that it can inform the user instead of having the
> whole tool exit to the command line.

OK, so that you want to see 

ret = library_func();
if (ret < 0)	/* Something wrong happened */
	return ret;

instead of 

library_func();
hopefully_executed_next_func();



> It may well be that some specific operation needs lots of resources but
> many other don't, panic'c because the one that requires lots of
> resources can't be performed, bringing down a gui/tui is really nasty.

Hmm, agreed. But I'd like to have some API for storing dying^H^H^H^H^Herror
message. (maybe can we use setjump/longjump approach - like try/cache - for die()?)

Thank you,

> 
> Perhaps the answer will be the same as for when people added panic calls
> in the kernel in the past, "you're screwed up anyway if that happens",
> but it just feels wrong :-\
> 
> In the DWARF bits it has even the added twist namespace collapse with
> DIE 8-)
> 
> - Arnaldo
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

-- 
Masami Hiramatsu
e-mail: mhiramat@redhat.com
