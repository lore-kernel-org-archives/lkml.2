Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754183Ab1JLVAB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Oct 2011 17:00:01 -0400
Received: from mail-dy0-f46.google.com ([209.85.220.46]:35714 "EHLO
	mail-dy0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752608Ab1JLU77 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Oct 2011 16:59:59 -0400
Message-ID: <4E95FFCA.2090604@gmail.com>
Date: Wed, 12 Oct 2011 22:59:54 +0200
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:7.0.1) Gecko/20110929 Thunderbird/7.0.1
MIME-Version: 1.0
To: Jiri Slaby <jslaby@suse.cz>
CC: gregkh@suse.de, linux-kernel@vger.kernel.org,
        Sukadev Bhattiprolu <sukadev@us.ibm.com>, Alan Cox <alan@redhat.com>
Subject: Re: [PATCH 4/4] TTY: call tty_driver_lookup_tty unconditionally
References: <4E8C6836.1090601@suse.cz> <1318411965-23917-1-git-send-email-jslaby@suse.cz> <1318411965-23917-4-git-send-email-jslaby@suse.cz>
In-Reply-To: <1318411965-23917-4-git-send-email-jslaby@suse.cz>
X-Enigmail-Version: 1.4a1pre
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/12/2011 11:32 AM, Jiri Slaby wrote:
> Commit 4a2b5fddd5 (Move tty lookup/reopen to caller) made the call to
> tty_driver_lookup_tty conditional in tty_open. It doesn't look like it
> was an intention. Or if it was, it was not documented in the changelog
> and the code now looks weird. For example there would be no need to
> remember the tty driver and tty index. Further the condition depends
> on a tty which we drop a reference of already.
> 
> If I'm looking correctly, this should not matter thanks to the locking
> currently done there. Thus, tty_driver->ttys[idx] cannot change under
> our hands. But anyway, it makes sense to change that to the old
> behaviour.

Well, this doesn't work for ptys. devpts lookup code expects an inode to
be one of devpts filesystem (/dev/pts/*), not something on tmpfs like
/dev/tty. So it looks like the change was intentional, but very
undocumented and leaving there some unused code.

Now, I don't know what to do with the tty being around with a dropped
reference. Maybe nothing in the presence of the BTM which I *think*
prevents tty to go now.

Also I have just found that having ptm_unix98_lookup is pointless. For
master, we have ptmx_open which doesn't call lookup. And if it did, it
would trigger BUG_ON in devpts_get_tty called from ptm_unix98_lookup.

thanks,
-- 
js
