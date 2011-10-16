Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932120Ab1JPTTX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Oct 2011 15:19:23 -0400
Received: from e2.ny.us.ibm.com ([32.97.182.142]:44397 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932091Ab1JPTTW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Oct 2011 15:19:22 -0400
Date: Sun, 16 Oct 2011 12:20:57 -0700
From: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
To: Jiri Slaby <jirislaby@gmail.com>
Cc: Jiri Slaby <jslaby@suse.cz>, gregkh@suse.de, linux-kernel@vger.kernel.org,
        Sukadev Bhattiprolu <sukadev@us.ibm.com>, Alan Cox <alan@redhat.com>,
        hpa@zytor.com
Subject: Re: [PATCH 4/4] TTY: call tty_driver_lookup_tty unconditionally
Message-ID: <20111016192057.GB14883@us.ibm.com>
References: <4E8C6836.1090601@suse.cz>
 <1318411965-23917-1-git-send-email-jslaby@suse.cz>
 <1318411965-23917-4-git-send-email-jslaby@suse.cz>
 <4E95FFCA.2090604@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4E95FFCA.2090604@gmail.com>
X-Operating-System: Linux 2.0.32 on an i486
User-Agent: Mutt/1.5.20 (2009-06-14)
x-cbid: 11101619-5112-0000-0000-0000010D2CE0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ccing H.Peter Anvin.

Jiri Slaby [jirislaby@gmail.com] wrote:
| On 10/12/2011 11:32 AM, Jiri Slaby wrote:
| > Commit 4a2b5fddd5 (Move tty lookup/reopen to caller) made the call to
| > tty_driver_lookup_tty conditional in tty_open. It doesn't look like it
| > was an intention. Or if it was, it was not documented in the changelog
| > and the code now looks weird. For example there would be no need to
| > remember the tty driver and tty index. Further the condition depends
| > on a tty which we drop a reference of already.
| > 
| > If I'm looking correctly, this should not matter thanks to the locking
| > currently done there. Thus, tty_driver->ttys[idx] cannot change under
| > our hands. But anyway, it makes sense to change that to the old
| > behaviour.
| 
| Well, this doesn't work for ptys. devpts lookup code expects an inode to
| be one of devpts filesystem (/dev/pts/*), not something on tmpfs like
| /dev/tty. So it looks like the change was intentional, but very
| undocumented and leaving there some unused code.

Yes this was intentional - even though the tty_driver_lookup() was
unconditional in tty_init_dev() I believe it did not do anything useful
when called from ptmx_open(). ptmx_open() would be setting up a new pty and
the lookup would not find a tty.

Would the following change to tty_open() help ?

got_driver:
+	/* check if we are opening a new pty or reopening an existing tty */
        if (!tty) {
-	/* check whether we're reopening an existing tty */
                tty = tty_driver_lookup_tty(driver, inode, index);

I am not sure about the unused code you refer to above. Can you please
clarify ?

Sukadev

