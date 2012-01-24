Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755936Ab2AXKwa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jan 2012 05:52:30 -0500
Received: from mail-qw0-f46.google.com ([209.85.216.46]:59490 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755734Ab2AXKw2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jan 2012 05:52:28 -0500
MIME-Version: 1.0
In-Reply-To: <1327390229-30170-1-git-send-email-levinsasha928@gmail.com>
References: <1327390229-30170-1-git-send-email-levinsasha928@gmail.com>
Date: Tue, 24 Jan 2012 11:52:27 +0100
Message-ID: <CAJK669acbPLTxTDrk_uqdB2FmewcSA+HF0qEFADgT8YdfNMcpQ@mail.gmail.com>
Subject: Re: [PATCH] net: caif: Don't act on notification for non-caif devices
From: =?UTF-8?Q?Sjur_Br=C3=A6ndeland?= <sjurbren@gmail.com>
To: Sasha Levin <levinsasha928@gmail.com>
Cc: davem@davemloft.net, davej@redhat.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Sasha,

> Since the list of CAIF devices is stored in the net generic struct in each
> net namespace, which is not initialized at that point, we see the following
> BUG():
>
> [  200.752016] kernel BUG at include/net/netns/generic.h:40!
...
> [  200.752016] Call Trace:
> [  200.752016]  [<ffffffff825c3cea>] ? get_cfcnfg+0x3a/0x180
> [  200.752016]  [<ffffffff821cf0b0>] ? lockdep_rtnl_is_held+0x10/0x20
> [  200.752016]  [<ffffffff825c41be>] caif_device_notify+0x2e/0x530

Argh, my bad. This issue has been identified and fixed by David
Woodhouse earlier,
but was reintroduced again by me when adding support for CAIF over NCM.
The CAIF code is handling if net_generic() returns NULL, but I missed that
net_generic() does BUG_ON().

> Instead, we'll first check if the device in the notification is a CAIF device:
>  - If it is - the net generic struct in that namespace must have been already
> initialized.
>  - If not - just ignore it as we don't care about other devices.
>
> Signed-off-by: Sasha Levin <levinsasha928@gmail.com>

Nack, we have to handle other device types than just ARPHDR_CAIF after
introducing
CAIF over USB/NCM. I'd rather fix this in netns by removing the BUG_ON
and return
NULL. How about this instead:

diff --git a/include/net/netns/generic.h b/include/net/netns/generic.h
index 3419bf5..0fc2eea 100644
--- a/include/net/netns/generic.h
+++ b/include/net/netns/generic.h
@@ -37,8 +37,10 @@ static inline void *net_generic(const struct net *net, int id

        rcu_read_lock();
        ng = rcu_dereference(net->gen);
-       BUG_ON(id == 0 || id > ng->len);
-       ptr = ng->ptr[id - 1];
+       if (id == 0 || id > ng->len)
+               ptr = NULL;
+       else
+               ptr = ng->ptr[id - 1];
        rcu_read_unlock();

        return ptr;

I'll post a patch for this soon.

Regards,
Sjur
