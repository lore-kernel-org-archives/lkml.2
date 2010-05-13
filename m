Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756131Ab0EMWLo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 May 2010 18:11:44 -0400
Received: from mx1.redhat.com ([209.132.183.28]:29653 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752573Ab0EMWLn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 May 2010 18:11:43 -0400
Message-ID: <4BEC790B.5000708@redhat.com>
Date: Thu, 13 May 2010 18:11:23 -0400
From: Masami Hiramatsu <mhiramat@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.9) Gecko/20100330 Fedora/3.0.4-1.fc11 Thunderbird/3.0.4
MIME-Version: 1.0
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
CC: Chase Douglas <chase.douglas@canonical.com>, linux-kernel@vger.kernel.org,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@elte.hu>
Subject: Re: perf: relative path to source for perf probe?
References: <AANLkTins2yCK-rvmdaaSQoBum4haHLhPx34EeJDg21Gg@mail.gmail.com> <20100513145826.GJ30926@ghostprotocols.net> <AANLkTin1w6OoS_6qzMqIizBxOGiV7DXJ936-hdHSFCD8@mail.gmail.com> <20100513173426.GK19192@ghostprotocols.net> <4BEC6DC2.4040207@redhat.com> <20100513214621.GA2124@ghostprotocols.net>
In-Reply-To: <20100513214621.GA2124@ghostprotocols.net>
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Arnaldo Carvalho de Melo wrote:
> Em Thu, May 13, 2010 at 05:23:14PM -0400, Masami Hiramatsu escreveu:
>> Arnaldo Carvalho de Melo wrote:
>>> Em Thu, May 13, 2010 at 06:01:10PM +0200, Chase Douglas escreveu:
>>>> On Thu, May 13, 2010 at 4:58 PM, Arnaldo Carvalho de Melo
>>>> <acme@ghostprotocols.net> wrote:
>>>>> Look in tools/perf/util/symbol.c, these variables are the ones tools use
>>>>> to govern how the symbol system work wrt finding vmlinux:
>>>>>
>>>>> symbol_conf.use_vmlinux_path
>>>>> symbol_conf.vmlinux_name
>>>>>
>>>>> In addition to this it will use what is in ~/.debug/ if it has a
>>>>> build-id in the perf.data header.
>>>>>
>>>>> The changes for support kvm also touched this and allow for some
>>>>> prefixing to look for guest symbols, generalizing that to make guest
>>>>> kernel vmlinux + modules relative location be reused to look for
>>>>> relative location for host kernel vmlinux + modules seems the way to go.
>>>>
>>>> After reading this some more, I think we are talking about two
>>>> different things. I think your notes above are referring to locating
>>>> the vmlinux image and other debug symbols. This seems to work fine for
>>>> me using the -k flag.
>>>
>>> What about finding the associated modules?
>>>
>>>> However, I'm encountering an issue where the source code location
>>>> isn't found. I think this is fairly specific to the probe command of
>>>> perf, which is fairly new, so maybe it's missing the same level of
>>>> support that the symbol finding code has?
>>>
>>> Annotation needs it, in top, report, too.
>>>
>>> But probably (haven't looked at the sources) the way to specify it will
>>> be different, since we rely on objdump to do the disassembly, we need to
>>> inform it where the sources are, but look at the source of all this, the
>>> relevant DWARF tags:
>>>
>>>  <0><b>: Abbrev Number: 1 (DW_TAG_compile_unit)
>>>     < c>   DW_AT_stmt_list   : 0x0      
>>>     <10>   DW_AT_ranges      : 0x0      
>>>     <14>   DW_AT_name        : /home/acme_unencrypted/git/linux-2.6-tip/arch/x86/kernel/head_64.S       
>>>     <57>   DW_AT_comp_dir    : /home/acme_unencrypted/git/build/v2.6.34-rc6-
>>
>> Actually, these doesn't help us so much. DW_AT_name shows the absolute path
>> of source file (and perf probe already have it), and DW_AT_comp_dir just 
>> shows where the object code has been stored (or where the make command ran).
> 
> IOW:
> 
> real_path = user_provided_path + (DW_AT_name - DW_AT_comp_dir)
> 
> + == concat
> 
> - remove initial string
> 
> if the project is build in place, i.e. in the kernel case, when one
> doesn't use 'make O='
> 
> But then, given user_provided_path what we can do is to find a match
> from the end of DW_AT_name, thus infering the missing (non-existent in
> DWARF) DW_AT_source_dir tag :-)

I recommend you to find a match from the top of DW_AT_name, because
we have many same-name files under kernel/ and arch/XXX/kernel/ :P


>> In this case (after compiling kernel, user moved its source into another
>> directory), we have to find the top directory of this source code.
>>
>> Imagine that, if user compiled code under /home/user/git-ksrc/, and 
>> it was moved under  /usr/src/2.6.x/, perf probe will be given an option
>> '-s /usr/src/2.6.x/'.
> 
> So, for the DW_AT_name example above, we would have these files:
> 
> At build time (DW_AT_name):
> 
> /home/acme_unencrypted/git/linux-2.6-tip/arch/x86/kernel/head_64.S
> 
> And at analysis time (using the path where the user moved all the source
> tree):
> 
> /usr/src/2.6.x/arch/x86/kernel/head_64.S
> 
> Putting then side by side:
> 
> /home/acme_unencrypted/git/linux-2.6-tip/arch/x86/kernel/head_64.S
>                           /usr/src/2.6.x/arch/x86/kernel/head_64.S
> 
> So know we know what DW_AT_source_dir is.

Sure :)

> 
> Implementation is left to the reader 8-)
> 
> - Arnaldo

Thank you,

-- 
Masami Hiramatsu
e-mail: mhiramat@redhat.com
