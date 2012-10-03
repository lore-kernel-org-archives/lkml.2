Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965344Ab2JCRJQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Oct 2012 13:09:16 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:50868 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964823Ab2JCRJO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Oct 2012 13:09:14 -0400
Date: Wed, 3 Oct 2012 18:09:07 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
        Ming Lei <ming.lei@canonical.com>,
        Greg KH <gregkh@linuxfoundation.org>, Kay Sievers <kay@vrfy.org>,
        Lennart Poettering <lennart@poettering.net>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Kay Sievers <kay@redhat.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Michael Krufky <mkrufky@linuxtv.org>,
        Ivan Kalvachev <ikalvachev@gmail.com>
Subject: Re: udev breakages - was: Re: Need of an ".async_probe()" type of
 callback at driver's core - Was: Re: [PATCH] [media] drxk: change it to use
 request_firmware_nowait()
Message-ID: <20121003170907.GA23473@ZenIV.linux.org.uk>
References: <4FE8CED5.104@redhat.com>
 <20120625223306.GA2764@kroah.com>
 <4FE9169D.5020300@redhat.com>
 <20121002100319.59146693@redhat.com>
 <CA+55aFyzXFNq7O+M9EmiRLJ=cDJziipf=BLM8GGAG70j_QTciQ@mail.gmail.com>
 <20121002221239.GA30990@kroah.com>
 <20121002222333.GA32207@kroah.com>
 <CA+55aFwNEm9fCE+U_c7XWT33gP8rxothHBkSsnDbBm8aXoB+nA@mail.gmail.com>
 <506C562E.5090909@redhat.com>
 <CA+55aFweE2BgGjGkxLPkmHeV=Omc4RsuU6Kc6SLZHgJPsqDpeA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFweE2BgGjGkxLPkmHeV=Omc4RsuU6Kc6SLZHgJPsqDpeA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 03, 2012 at 09:38:52AM -0700, Linus Torvalds wrote:
> Yeah, that bugzilla shows the problem with Kay as a maintainer too,
> not willing to own up to problems he caused.
> 
> Can you actually see the problem? I did add the attached patch as an
> attachment to the bugzilla, so the reporter there may be able to test
> it, but it's been open for a long while..
> 
> Anyway. Attached is a really stupid patch that tries to do the "direct
> firmware load" as suggested by Ivan. It has not been tested very
> extensively at all (but I did test that it loaded the brcmsmac
> firmware images on my laptop so it has the *potential* to work).

+	if (!S_ISREG(inode->i_mode))
+		return false;
+	size = i_size_read(inode);

Probably better to do vfs_getattr() and check mode and size in kstat; if
it's sufficiently hot for that to hurt, we are fucked anyway.

+		file = filp_open(path, O_RDONLY, 0);
+		if (IS_ERR(file))
+			continue;
+printk("from file '%s' ", path);
+		success = fw_read_file_contents(file, fw);
+		filp_close(file, NULL);

fput(file), please.  We have enough misuses of filp_close() as it is...

> We are apparently better off trying to avoid udev like the plague.
> Doing something very similar to this for module loading is probably a
> good idea too.

That, or just adding usr/udev in the kernel git tree and telling the
vertical integrators to go kiss a lamprey...
