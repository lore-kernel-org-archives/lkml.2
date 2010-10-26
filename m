Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757597Ab0JZVAD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Oct 2010 17:00:03 -0400
Received: from xenotime.net ([72.52.115.56]:34140 "HELO xenotime.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1754971Ab0JZVAC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Oct 2010 17:00:02 -0400
Date: Tue, 26 Oct 2010 13:59:57 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: lkml <linux-kernel@vger.kernel.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: Re: docbook: fix fatal error in linux/input.h
Message-Id: <20101026135957.62db12d2.rdunlap@xenotime.net>
In-Reply-To: <4CC736CE.80305@redhat.com>
References: <20101026114555.4b79977d.rdunlap@xenotime.net>
	<4CC7283D.3010205@redhat.com>
	<20101026121747.897eddc9.rdunlap@xenotime.net>
	<4CC736CE.80305@redhat.com>
Organization: YPO4
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 26 Oct 2010 18:15:10 -0200 Mauro Carvalho Chehab wrote:

> Em 26-10-2010 17:17, Randy Dunlap escreveu:
> > On Tue, 26 Oct 2010 17:13:01 -0200 Mauro Carvalho Chehab wrote:
> > 
> >> Em 26-10-2010 16:45, Randy Dunlap escreveu:
> >>> Hi,
> >>>
> >>> Recent commit 8613e4c2872a87cc309a42de2c7091744dc54d0e:
> >>> Author: Mauro Carvalho Chehab <mchehab@redhat.com>
> >>> Date:   Thu Sep 9 21:54:22 2010 -0700
> >>>     Input: add support for large scancodes
> >>>
> >>> causes a fatal error in docbook generation:
> >>>
> >>> linux-2.6.36-git8/DOC1/Documentation/DocBook/device-drivers.xml:40690: parser error : StartTag: invalid element name
> >>> #define INPUT_KEYMAP_BY_INDEX	(1 << 0)
> >>>                              	    ^
> >>>
> >>> I think that this message comes from xsltproc, but I'm not positive about that.
> >>> I also don't know of a really good fix for it.  However, I did find 2 ways to
> >>> work around the error:
> >>>
> >>> a/ move the #define value to after the end of the struct input_keymap_entry, like:
> >>>
> >>> /* flags bits: */
> >>> #define INPUT_KEYMAP_BY_INDEX	(1 << 0)
> >>>
> >>> or
> >>> b/ don't use the "<< 0" (can leave the #define where it is in this case):
> >>> #define INPUT_KEYMAP_BY_INDEX	(1)
> >>>
> >>> I have tested both of these patches and they work OK.
> >>> Are you OK with either of them?  or want to choose one?
> >>
> >>
> >> Hmm... probably, the first one is not correct.
> > 
> > Why not?  All it does is move the line to after the end of the struct.
> > 
> >> I suspect that the right way is to use something like:
> >>
> >> 	#define INPUT_KEYMAP_BY_INDEX	(1 &lt;&lt; 0)
> >>
> >> Could you please test if this would fix the issue?
> > 
> > You are suggesting putting that into include/linux/input.h ??
> > 
> > That would make sense if some tool converted "<<" to "&lt;&lt;".
> > And that may be where the problem is, but I don't know those tools.
> 
> 
> Hmm... such rule is already at DocBook/Makefile:
> 
> %.xml: %.c
>         @$($(quiet)gen_xml)
>         @(                            \
> 	   echo "<programlisting>";   \
>            expand --tabs=8 < $< |     \
>            sed -e "s/&/\\&amp;/g"     \
>                -e "s/</\\&lt;/g"      \
>                -e "s/>/\\&gt;/g";     \
>            echo "</programlisting>")  > $@
> 
> Not sure why this didn't work. It should have replaced the < from the c file.
> Maybe some patch broke Makefile?

Maybe that rule needs to apply to .h files also.

Would

%.xml: %.[hc]

work?


---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
