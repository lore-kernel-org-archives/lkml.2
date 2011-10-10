Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753691Ab1JJSys (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Oct 2011 14:54:48 -0400
Received: from tex.lwn.net ([70.33.254.29]:36253 "EHLO vena.lwn.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752925Ab1JJSyr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Oct 2011 14:54:47 -0400
Date: Mon, 10 Oct 2011 12:54:45 -0600
From: Jonathan Corbet <corbet@lwn.net>
To: jim.cromie@gmail.com
Cc: jbaron@redhat.com, joe@perches.com, bart.vanassche@gmail.com,
        greg@kroah.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 23/26] dynamic_debug: document pending queries,
 flags-filter, multiple queries
Message-ID: <20111010125445.3a1248e4@bike.lwn.net>
In-Reply-To: <1316642115-20029-24-git-send-email-jim.cromie@gmail.com>
References: <1316642115-20029-1-git-send-email-jim.cromie@gmail.com>
	<1316642115-20029-24-git-send-email-jim.cromie@gmail.com>
Organization: LWN.net
X-Mailer: Claws Mail 3.7.10 (GTK+ 2.24.6; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some of these comments are about the patch set as a whole, but done in the
context of the doc file changes.

>  Dynamic debug has even more useful features:
>  
> - * Simple query language allows turning on and off debugging statements by
> -   matching any combination of:
> + * Simple query language allows turning on and off debugging statements
> +   by matching any combination of 0 or 1 of:
>  
>     - source filename
>     - function name
>     - line number (including ranges of line numbers)
>     - module name
>     - format string
> +   - current debugging flags

This is totally confusing; you've replaced all the things that can be
matched with a single-entry itemized list of "current debugging flags"?

> + * Provides a debugfs control file: <debugfs>/dynamic_debug/control
> +   which can be read to display the complete list of known debug
> +   statements, to help guide you.
>  
>  Controlling dynamic debug Behaviour
>  ===================================
>  
> -The behaviour of pr_debug()/dev_dbg()s are controlled via writing to a
> -control file in the 'debugfs' filesystem. Thus, you must first mount the debugfs
> -filesystem, in order to make use of this feature. Subsequently, we refer to the
> -control file as: <debugfs>/dynamic_debug/control. For example, if you want to
> -enable printing from source file 'svcsock.c', line 1603 you simply do:
> +The behaviour of pr_debug()/dev_dbg()/net_dbg()s are controlled via
> +writing to a control file in the 'debugfs' filesystem. Thus, you must
> +first mount the debugfs filesystem, in order to make use of this
> +feature.  Subsequently, we refer to mount point as $DBGFS, and the
> +control file as $CONTROL.  So if you want to enable printing from

Why the $CONTROL stuff?  I can see parameterizing teh debugfs location,
even though that discussion seems to have settled down.  But, if you miss
the line at the top of this section, you'll never know where $CONTROL is.
It doesn't change, why obfuscate it?

> +source file 'svcsock.c', line 1603 you simply do:
>  
> -nullarbor:~ # echo 'file svcsock.c line 1603 +p' >
> -				<debugfs>/dynamic_debug/control
> +nullarbor:~ # echo file svcsock.c line 1603 +p > $CONTROL
>  
>  If you make a mistake with the syntax, the write will fail thus:
>  
> -nullarbor:~ # echo 'file svcsock.c wtf 1 +p' >
> -				<debugfs>/dynamic_debug/control
> +nullarbor:~ # 'echo file svcsock.c wtf 1 +p' > $CONTROL
>  -bash: echo: write error: Invalid argument

I don't think you tested that last one :)  The bash error output will be
other than shown here.

> +  # comments and blank lines ok, but cannot contain semicolon
> +  # multiple cmds per line, 1st must be terminated by semicolon
> +  func foo p=_	; func buzz p=_
> +  func bar p=_	; func bum  p=_
> +  func yak p=_	; # trailing comment, requires semicolon to terminate cmd

That seems like a slightly strange set of rules.  By Least Surprise, I
would expect # to start a comment anywhere and to go the end of the line,
semicolons or not.  

> +voyage:~# cat dyndbg-cmdfile > $CONTROL
> +dynamic_debug:ddebug_exec_queries: processed 7 queries, with 0 errs

Who produces the "processed 7 queries" message?  It's not that "cat"
command...

> +Multiple commands are processed independently, this allows you to send
> +commands which may fail, for example if a module is not present.  The
> +last failing command returns its error.
> +
> +Or you can do an "echo" for each, like:
> +
> +nullarbor:~ # echo 'file svcsock.c line 1603 +p' > $CONTROL; \
> +> echo 'file svcsock.c line 1563 +p' > $CONTROL

Is there some reason for the backslash-escaped newline here?

>  A match specification comprises a keyword, which controls the attribute
>  of the callsite to be compared, and a value to compare against.  Possible
> @@ -125,12 +142,13 @@ match-spec ::= 'func' string |
>  	       'module' string |
>  	       'format' string |
>  	       'line' line-range
> +// Note: no wildcards, regexs are accepted

Why the // notation?  And what does that line mean?  There's a full regular
expression interpreter in this code now?  I note that there are no
regex-based examples in this file.

> +flags specification
> +===================
>  
> -=
> -    set the flags to the given flags
> +The flags specification matches the regexp: ^[flmpta_]*[-+=][flmpta_]*$
> +and has 3 parts:
>  
> -The flags are:
> +flags filter (optional):
> +    The filter precedes the operation [-+=], and constrains matching
> +    to thoses callsite with given flags set.  This allows altering
> +    flags on callsites with filtered flag values
>  
> -f
> -    Include the function name in the printed message
> -l
> -    Include line number in the printed message
> -m
> -    Include module name in the printed message
> -p
> -    Causes a printk() message to be emitted to dmesg
> -t
> -    Include thread ID in messages not generated from interrupt context
> +      pm+t	# add t to enabled sites which have m

How about "add the thread ID to sites that already have module-name
printing enabled?  Same with the rest.  

> +Pending queries
> +===============
> +
> +Queries submitted with 'a' are applied to current callsites as above,
> +but are also added to a pending list.  When a module is loaded later,
> +pending queries are applied to the module in the order given.
> +
> +This is done before the module_init() routine is run, so pr_debug()s
> +can be active during initialization.  To better support module
> +debugging, pending queries remain on the list through modprobe-rmmod
> +cycles.

So this functionality seems to be the whole point of much of this patch
set.  That's a lot of stuff to turn on printks during module_init().  I
can't help but wonder: wouldn't it be easier and better to just recognize
the ddebug_query= parameter at module load time?  Then you could drop this
whole pending queries mechanism, the expanded syntax, new control file, and
so on...?  What am I missing?

> +You can review currently pending queries by catting or grepping
> +$DEBUFS/dynamic_debug/pending.  To simplify removal via
> +cut-paste-edit, its format is similar to the query syntax:
> +
> +  root@voyage:~# cat /dbg/dynamic_debug/pending
> +  # func file module format line flags mask
> +  ...
> +   func a299 line 0-0 =pa
> +   func a300 line 0-0 =pa

I don't get the "line 0-0" stuff either.  Why does it exist?  Its meaning
is far from intuitive.

> +Deleting or altering a pending query requires an exact match on most
> +of the match-spec; the same string specs must be given, but 'line 0-0'
> +matches with '' and vice-versa.  The filter-spec is ignored for

...and that doesn't really clarify things for me.  Sorry for being so
dense. 

> +  # removes PQ-1 (exact match with PQ-1), disables active callsites (if any)
> +  voyage:~# dbg_query module foo line 0-0 ap=

And again...how is "line 0-0" an "exact match"?

> +Altering a pending query ('a' in filter) will also alter the callsites
> +that it applies to (subject to filter match), but changing the active
> +callsites (using a query without the 'a') does not change the pending
> +query that applied it.

Why?  If you really need to keep pending queries around, why wouldn't they
be either totally independent of active queries, or completely tied to
them?  From this kind of inconsistency unpleasant surprises are born.

>  // enable all 12 messages in the function svc_process()
> -nullarbor:~ # echo -n 'func svc_process +p' >
> -				<debugfs>/dynamic_debug/control
> +nullarbor:~ # echo -n 'func svc_process +p' > $CONTROL
>  
>  // disable all 12 messages in the function svc_process()
> -nullarbor:~ # echo -n 'func svc_process -p' >
> -				<debugfs>/dynamic_debug/control
> +nullarbor:~ # echo -n 'func svc_process -p' > $CONTROL

Unless you're going to take responsibility for updating the document
whenever somebody patches svc_process(), I'd take out the exact count of
the number of messages.

> +// send query-command file to control
> +root@voyage:~# cat dyndbg-cmdfile > $CONTROL
> +dynamic_debug:ddebug_proc_open: called
> +dynamic_debug:ddebug_proc_write: read 500 bytes from userspace
> +dynamic_debug:ddebug_exec_queries: query 0: "func foo p=_	"
> +dynamic_debug:ddebug_tokenize: split into words: "func" "foo" "p=_"
> +dynamic_debug:ddebug_parse_query: parsed func="foo" file="" module="" format="" lineno=0-0

This doesn't seem like a particularly useful example; one can probably
assume that readers know about cat and I/O redirection.  

Thanks,

jon
