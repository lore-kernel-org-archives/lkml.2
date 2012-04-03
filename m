Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754631Ab2DCOcz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Apr 2012 10:32:55 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:59290 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751872Ab2DCOcy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Apr 2012 10:32:54 -0400
Message-ID: <1333463572.26079.31.camel@joe2Laptop>
Subject: Re: [PATCH] printk(): add KERN_CONT where needed
From: Joe Perches <joe@perches.com>
To: Kay Sievers <kay@vrfy.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Len Brown <lenb@kernel.org>
Date: Tue, 03 Apr 2012 07:32:52 -0700
In-Reply-To: <CAPXgP13fDRZtAvV651NPqQ2TgUEtb+MX1EhKhwirAgoiNOg5tQ@mail.gmail.com>
References: <1333415903.860.0.camel@mop>
	 <1333420612.26079.6.camel@joe2Laptop>
	 <CAPXgP12jX37GLgMJQuDYEi6q5A2Ma3d+e+_sNkFVdYfwsdMrtQ@mail.gmail.com>
	 <1333424865.26079.9.camel@joe2Laptop>
	 <CAPXgP13fDRZtAvV651NPqQ2TgUEtb+MX1EhKhwirAgoiNOg5tQ@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-04-03 at 12:30 +0200, Kay Sievers wrote:
> On Tue, Apr 3, 2012 at 05:47, Joe Perches <joe@perches.com> wrote:
> > I think you should do it "right" rather than add
> > trivial markers.
> 
> The trivial markers _are_ correct. And they really fix things as soon
> as we start storing machine-readable records with printk(), instead of
> blindly glueing bytes together with each printk() call, for humans to
> puzzle with them if things go wrong.

These KERN_CONT changes don't _fix_ things,
they just make it less likely to cause problems.

Imagine two threads with printks extended with
KERN_CONT

Thread 1:                                 Thread 2:
printk(KERN_INFO "info message: ");
                                          printk(KERN_ERR "err message: ");
printk(KERN_CONT "online\n");
                                          printk(KERN_CONT "offline\n");

Instead of a guarantee of "info message: online" and
"err message: offline", buffering could still join
the messages to "err message: online".

I believe the only _guaranteed_ way to correctly
assemble these messages is to use a initiator with
a cookie and pass that cookie to assembling printks.

Something like:

	cookie = multi_printk_start()
	multi_printk(cookie, level fmt, ...);
	...
	multi_printk_end(cookie);

Though get_current() might be a reasonable cookie
so perhaps the multi_ variants aren't needed.

git.kernel.org isn't responding right now.  I
can't read the link you sent me privately to
check if you are using get_current() or some
other current_thread_info() constuct.

