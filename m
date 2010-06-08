Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754854Ab0FHJ34 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jun 2010 05:29:56 -0400
Received: from moutng.kundenserver.de ([212.227.17.8]:52357 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752745Ab0FHJ3y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jun 2010 05:29:54 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: "Masayuki Ohtake" <masa-korg@dsn.okisemi.com>
Subject: Re: [PATCH] Topcliff PHUB: Generate PacketHub driver
Date: Tue, 8 Jun 2010 11:29:48 +0200
User-Agent: KMail/1.12.2 (Linux/2.6.31-19-generic; KDE/4.3.2; x86_64; ; )
Cc: "LKML" <linux-kernel@vger.kernel.org>,
       "Andrew" <andrew.chih.howe.khor@intel.com>,
       "Intel OTC" <joel.clark@intel.com>, "Wang, Qi" <qi.wang@intel.com>,
       "Wang, Yong Y" <yong.y.wang@intel.com>
References: <4C08D268.6000404@dsn.okisemi.com> <201006071537.27140.arnd@arndb.de> <002e01cb06e7$69846f10$66f8800a@maildom.okisemi.com>
In-Reply-To: <002e01cb06e7$69846f10$66f8800a@maildom.okisemi.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201006081129.48362.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX19VcF9VG70iUooqLRM6l7TDEyGwWYGV0BrHntO
 pwgBgJA8kafO/Xk7dfGVkkVY3fObJCeeMHtS+veuAPLwAh1Nsb
 3tpV/zxbI6bhmHmQRqLmA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 08 June 2010, Masayuki Ohtake wrote:
> We are studying your indication.
> > My feeling is that this ioctl interface is too
> > low-level in general. You only export access to specific
> > registers, not to functionality exposed by them.
> > The best kernel interfaces are defined in a way that
> > is independent of the underlying hardware and
> > convert generic commands into device specific commands.
> 
> I have a question.
> We don't know 'generic commands' concretely.
> Let me know 'generic commands' in detail.

I have not seen the application using the driver, but
a better abstraction IMHO would be to take an abstraction
you have in your application and move it into the kernel.

I can be more specific if you tell me where to find the
source of the application. Generally speaking, you'd
transform a function like

/* the function that knows how to do 'this' */
int phub_do_this(int phub_fd, unsigned long arg)
{
	struct pch_phub_req req = {
		.addr_offset = SOME_ADDR_OFF,
	};
	ioctl(fd, IOCTL_PHUB_READ_REG, &req);

	if (req.data & SOME_BITS)
		return ERROR;

	req.addr_offset = ANOTHER_ADDR_OFF;
	req.data = arg | REALLY_DO_IT_BITMASK;

	ioctl(fd, IOCTL_PHUB_WRITE_REG, &req);

	return 0;
}

into another function that does the same thing but
without knowing anything about the registers:

/* the same function on the abstract interface */
int phub_do_this_new(int phub_fd, unsigned long arg)
{
	return ioctl(phub_fd, IOCTL_PHUB_DO_THIS, &arg);
}

	Arnd
