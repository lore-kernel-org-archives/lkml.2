Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752858Ab1IPKiZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Sep 2011 06:38:25 -0400
Received: from out3.smtp.messagingengine.com ([66.111.4.27]:39387 "EHLO
	out3.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751756Ab1IPKiY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Sep 2011 06:38:24 -0400
X-Sasl-enc: 14PhKp0dZGtpSdH0h8zrdRwvrrcspbw+jMP+pcDLEj2M 1316169502
Subject: Re: [PATCH] Force same size of struct autofs_v5_packet on x86 and
 x86_64
From: Ian Kent <raven@themaw.net>
To: Thomas Meyer <thomas@m3y3r.de>
Cc: Al Viro <viro@ZenIV.linux.org.uk>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        dhowells@redhat.com
In-Reply-To: <20110916101903.GI2203@ZenIV.linux.org.uk>
References: <1316167604.6545.84.camel@localhost.localdomain>
	 <20110916101903.GI2203@ZenIV.linux.org.uk>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 16 Sep 2011 18:38:16 +0800
Message-ID: <1316169496.8502.6.camel@perseus.themaw.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 (2.32.3-1.fc14) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-09-16 at 11:19 +0100, Al Viro wrote:
> On Fri, Sep 16, 2011 at 12:06:38PM +0200, Thomas Meyer wrote:
> > autofs_v5_packet is 300 bytes on x86 and 304 bytes on x86_64.
> > This difference is wrong and leads to a hang in systemd when running
> > a x86 userspace on an x86_64 kernel.
> 
> NAK.
> 
> You are talking about the userland ABI.  With existing users.  Changing
> it might help systemd (what the hell is it doing with autofs, anyway?),
> but breaking existing binaries (you know, ones that *do* have some business
> dealing with autofs) is not acceptable.

That's right.

Certainly my mistake (made a long time ago) and when I realized it I
decided I would need to handle it in user space for the same reasons Al
has mentioned.

I think this should be enough (but any further recommendations are
welcome, apart from the fact we might get new archs):

static size_t get_kpkt_len(void)
{
        size_t pkt_len = sizeof(struct autofs_v5_packet);
        struct utsname un;

        uname(&un);

        if (pkt_len % 8) {
                if (strcmp(un.machine, "alpha") == 0 ||
                    strcmp(un.machine, "ia64") == 0 ||
                    strcmp(un.machine, "x86_64") == 0 ||
                    strcmp(un.machine, "ppc64") == 0)
                        pkt_len += 4;

        }

        return pkt_len;
}

