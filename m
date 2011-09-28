Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754367Ab1I1R1l (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Sep 2011 13:27:41 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:35733 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753999Ab1I1R1k convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Sep 2011 13:27:40 -0400
MIME-Version: 1.0
In-Reply-To: <1317185489.19340.22.camel@Joe-Laptop>
References: <1316642115-20029-1-git-send-email-jim.cromie@gmail.com>
 <1316642115-20029-26-git-send-email-jim.cromie@gmail.com> <1316725066.29447.16.camel@Joe-Laptop>
 <CAJfuBxxZdNRZAix8ARUjqjNzrQeG2iVea_rMYKysOaX4c=Avig@mail.gmail.com>
 <1317166589.19340.14.camel@Joe-Laptop> <CAJfuBxyZ63mi_onv8uWc3MCGgKDPfQMOgUOT7isJ-hA=o7sfqA@mail.gmail.com>
 <1317185489.19340.22.camel@Joe-Laptop>
From: Jim Cromie <jim.cromie@gmail.com>
Date: Wed, 28 Sep 2011 11:27:09 -0600
Message-ID: <CAJfuBxxoJ=KvzS-XgD6h7oXZ==xOC72_1YiR6shkY=5wC7CNmw@mail.gmail.com>
Subject: Re: [PATCH 25/26] dynamic_debug: add pr_fmt_dbg() for dynamic_pr_debug
To: Joe Perches <joe@perches.com>
Cc: jbaron@redhat.com, bart.vanassche@gmail.com, greg@kroah.com,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 27, 2011 at 10:51 PM, Joe Perches <joe@perches.com> wrote:
> On Tue, 2011-09-27 at 20:54 -0600, Jim Cromie wrote:
>> Cleanest way is to drop the original synonym, and just use
>> warn (its shorter), but that creates some churn (havent grepped to see
>> how much).
>> I picked what looked like least effort & fewest corner-cases.
>> ICBW..
>
> #ifndef pr_fmt_warning
> #define pr_fmt_warning pr_fmt_warn
> #endif
>

you've made it conditional, where line 203 is not. why ?
    201 #define pr_warning(fmt, ...) \
    202         printk(KERN_WARNING pr_fmt_warn(fmt), ##__VA_ARGS__)
    203 #define pr_warn pr_warning
    204 #define pr_notice(fmt, ...) \

Also, though minor, 203 adds pr_warn as the shortcut,
youve suggested the opposite.  I presume this is an oversight.

>> > What did you think of avoiding all of this and
>> > having __dynamic_pr_debug move the fmt pointer over
>> > any initial KBUILD_MODULE ": "
>> >
>> > int __dynamic_pr_debug(struct _ddebug *descriptor, const char *fmt, ...)
>> > {
>> > [...]
>> >        size_t modsize = strlen(descriptor->modname);
>> >        if (0 == strncmp(fmt, descriptor->modname, modsize) &&
>> >            0 == strncmp(fmt + modsize, ": ", 2))
>> >                fmt += modsize + 2;
>> >        vprintk(fmt, ...)
>> > ?
>>
>> I was getting to that... ;-)
>> Im not crazy about it.  It feels like too much ..
>> Its a runtime workaround for what I think is a
>> problem in users' (or header's) #defines.
>
> I think exactly the opposite myself.
>
> I think all of the '#define pr_fmt(fmt) KBUILD_MODNAME ": "'
> are effectivly useless and I will eventually delete them.
>
> The printk subsystem should look up the module name and
> prefix them to the printk akin to how the dynamic_debug
> system does.  Except the module name should be a singleton.

hmm, maybe Ive missed something in your argument.

For non-dynamic-debug builds, it seems you still want
the MODNAME in the pr_(crit|warn|info|debug) output,
you just dont like the hundreds of defines throughout drivers/*

 linux-2.6]$ grep -r pr_fmt drivers/ |wc
    427    2556   32040
 linux-2.6]$ grep -r pr_fmt drivers/ | grep KBUILD_MODNAME |wc
    303    1827   22567

Your runtime check-and-skip-MODNAME code above
fixes dynamic-debug so that works around user defines
doing:
#define pr_fmt(fmt) KBUILD_MODNAME ": "

This would let user of a dynamic-debug enabled kernel
add MODNAME selectively, with +m >$CONTROL


But ISTM this does the same:

diff --git a/include/linux/printk.h b/include/linux/printk.h
index e21de7e..cf17986 100644
--- a/include/linux/printk.h
+++ b/include/linux/printk.h
@@ -148,8 +148,17 @@ static inline void setup_log_buf(int early)

 extern void dump_stack(void) __cold;

+/* Set pr_fmt default to most common, useful case */
 #ifndef pr_fmt
-#define pr_fmt(fmt) fmt
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+#endif
+/* except for dynamic-debug, where user can enable it, and we dont
+   want to print it 2x
+ */
+#if defined(CONFIG_DYNAMIC_DEBUG)
+#ifndef pr_fmt_debug
+#define pr_fmt_debug(fmt) fmt
+#endif
 #endif

 #ifndef pr_fmt_emerg


This sets default to work for the 303 common cases,
allowing the removal of their defines:
  #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt

It also allows existing non-standard uses to work as is:
  drivers/sh/intc/dynamic.c:#define pr_fmt(fmt) "intc: " fmt

Your suggested pr_fmt_warning, etc allow severity specific
customizations to override, w/o changing all the others..

And in dynamic-debug kernels, the default pr_fmt_debug
is reset so MODNAME isnt printed, except by the user:
~]#  echo +m > $CONTROL

IOW, it seems to take care of everything, w/o runtime workarounds.
With agreement on this, I can fold above patch into 25/26
(which Ive updated here to also fix pr_*_once, pr_*_ratelimited macros),
and we can move against those 303 irritants at our leisure (there is
no flag day)

thanks
Jim
