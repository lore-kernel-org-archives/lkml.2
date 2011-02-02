Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754782Ab1BBRkT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Feb 2011 12:40:19 -0500
Received: from cantor2.suse.de ([195.135.220.15]:44422 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754681Ab1BBRkS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Feb 2011 12:40:18 -0500
Date: Wed, 2 Feb 2011 18:40:15 +0100
From: Marcus Meissner <meissner@suse.de>
To: davem@davemloft.net, eric.dumazet@gmail.com, ebiederm@xmission.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        gorcunov@openvz.org
Subject: af_unix unix_getname: return size for unnamed sockets too small?
Message-ID: <20110202174015.GB25515@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Organization: SUSE LINUX Products GmbH, GF: Markus Rex, HRB 16746 (AG Nuernberg)
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

In net/unix/af_unix.c::unix_getname() there is a small problem:

        if (!u->addr) {
                sunaddr->sun_family = AF_UNIX;
                sunaddr->sun_path[0] = 0;		// not copied out
                *uaddr_len = sizeof(short);
        } else {
                struct unix_address *addr = u->addr;

                *uaddr_len = addr->len;
                memcpy(sunaddr, addr->name, *uaddr_len);
        }

The if (!u->addr) case will not copy out the \0 in the sun_path, as
uaddr_len is just the size of sun_family.

(Shown by socat crashing after decoding gethostname return and expected
sun_path to be a valid string (and not seeing the \0)).

Should it perhaps be *uaddr_len = sizeof(short)+sizeof(char)?

Ciao, Marcus
