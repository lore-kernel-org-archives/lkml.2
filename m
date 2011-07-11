Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753078Ab1GKTGy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jul 2011 15:06:54 -0400
Received: from mail-gw0-f46.google.com ([74.125.83.46]:59289 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752155Ab1GKTGx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jul 2011 15:06:53 -0400
MIME-Version: 1.0
In-Reply-To: <CAO+b5-rP8JAqe5pV7x_4RR5aumpHi4JG5diHehe5BiS_QwzSvw@mail.gmail.com>
References: <CAJfuBxyhh=3rO9MLkfDic16mij4A6NLXEQnhsvHEmBKokMoF7A@mail.gmail.com>
 <CAO+b5-rP8JAqe5pV7x_4RR5aumpHi4JG5diHehe5BiS_QwzSvw@mail.gmail.com>
From: Jim Cromie <jim.cromie@gmail.com>
Date: Mon, 11 Jul 2011 13:06:22 -0600
Message-ID: <CAJfuBxxvDhRgwfosZHZEAsgeLsAzDigHh-j3mC+8aJByR-=GkQ@mail.gmail.com>
Subject: Re: [ patch 00/21 ] support multiple, pending ddebugs at kernel-boot
To: Bart Van Assche <bvanassche@acm.org>
Cc: jbaron@redhat.com, linux-kernel@vger.kernel.org, joe@perches.com,
        gregkh@suse.de, gnb@fmeh.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 11, 2011 at 12:30 PM, Bart Van Assche <bvanassche@acm.org> wrote:
> On Mon, Jul 11, 2011 at 5:21 PM, Jim Cromie <jim.cromie@gmail.com> wrote:
>> On Mon, Jul 11, 2011 at 1:46 AM, Jim Cromie <jim.cromie@gmail.com> wrote:
>>>
>>> This patchset extends dynamic-debug facility to allow
>>> use of pr_debug() within a loadable module's module_init()
>>> function.  Query/rules can be given on the boot-line,
>>> and are saved to a pending list if they cannot be applied
>>> immediately.  Later, when the module is being loaded, the
>>> pending list is scanned, and matching rules are applied.
>>> Thus pr_debug() calls in the module's initialization function
>>> are active when it is invoked.
>>>
>>>
>>> Changes since rev1:
>>>
>>> - rebased on top of Jasons & Joes patchset
>>> - fixed accidental unescape removal, noted by Bart
>>> - trim src-path patch checks for matching prefix before trimming
>>>  should now work for out-of-tree modules.
>>> - undid verbose newline-strip in exec-queries - Bart
>>> - verbose param 644, not 744 - Bart, Greg
>>> - whitespace - Bart
>>> - added 'a' flag - Jason, Bart
>>> - drop pending_max - Bart
>
> As far as I can see with v2 of this patch set a query gets on the
> pending list if either +a has been specified or no matches were found
> the first time a query is run. Are both mechanisms necessary ? If not,
> I propose to leave out the second. That will not only allow to
> simplify the code somewhat but will also reduce confusion for
> dynamic_printk users.
>

Both conditions are necessary:
- 'a' flag required,
- query not directly applicable.

root@voyage:~# echo 1 > /sys/module/dynamic_debug/parameters/verbose

root@voyage:~# echo "module nosuch +p" > /dbg/dynamic_debug/control
dynamic_debug:ddebug_proc_open: called
dynamic_debug:ddebug_proc_write: read 17 bytes from userspace
dynamic_debug:ddebug_exec_queries: query 0: "module nosuch +p
"
dynamic_debug:ddebug_tokenize: split into words: "module" "nosuch" "+p"
dynamic_debug:ddebug_parse_query: parsed q->function="(null)"
q->filename="(null)" q->module="nosuch" q->format="(null)"
q->lineno=0-0
dynamic_debug:ddebug_parse_flags:  flags_filter=0x0
 op='+'
 flags=0x1
dynamic_debug:ddebug_parse_flags: *flagsp=0x1 *maskp=0xffffffff
dynamic_debug:ddebug_exec_query: no match on: q->function="(null)"
q->filename="(null)" q->module="nosuch" q->format="(null)"
q->lineno=0-0
dynamic_debug:ddebug_exec_query: nfound 0 on q->function="(null)"
q->filename="(null)" q->module="nosuch" q->format="(null)"
q->lineno=0-0
dynamic_debug:ddebug_exec_queries: processed 1 queries, with 0 errs

root@voyage:~# cat /sys/module/dynamic_debug/parameters/pending_ct
0

root@voyage:~# echo "module nosuch +ap" > /dbg/dynamic_debug/control
dynamic_debug:ddebug_proc_open: called
dynamic_debug:ddebug_proc_write: read 18 bytes from userspace
dynamic_debug:ddebug_exec_queries: query 0: "module nosuch +ap
"
dynamic_debug:ddebug_tokenize: split into words: "module" "nosuch" "+ap"
dynamic_debug:ddebug_parse_query: parsed q->function="(null)"
q->filename="(null)" q->module="nosuch" q->format="(null)"
q->lineno=0-0
dynamic_debug:ddebug_parse_flags:  flags_filter=0x0
 op='+'
 flags=0x21
dynamic_debug:ddebug_parse_flags: *flagsp=0x21 *maskp=0xffffffff
dynamic_debug:ddebug_save_pending: add to pending:
q->function="(null)" q->filename="(null)" q->module="nosuch"
q->format="(null)" q->lineno=0-0
dynamic_debug:ddebug_save_pending: query saved as pending 1
dynamic_debug:ddebug_exec_query: nfound 0 on q->function="(null)"
q->filename="(null)" q->module="nosuch" q->format="(null)"
q->lineno=0-0
dynamic_debug:ddebug_exec_queries: processed 1 queries, with 0 errs

root@voyage:~# cat /sys/module/dynamic_debug/parameters/pending_ct
1

> Bart.
>

thanks
~jimc
