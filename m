Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754849Ab2D3AeL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Apr 2012 20:34:11 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:52342 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754172Ab2D3AeK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Apr 2012 20:34:10 -0400
MIME-Version: 1.0
In-Reply-To: <4F9DDCB6.1070908@zytor.com>
References: <20120429205429.63CCD7C0064@ra.kernel.org> <4F9DD994.70202@zytor.com>
 <CA+55aFy72rPMq3M2_PU0ue45Fb38_Effrfhu2uOpdVXt9H1XOg@mail.gmail.com> <4F9DDCB6.1070908@zytor.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Sun, 29 Apr 2012 17:33:48 -0700
X-Google-Sender-Auth: SylTto4vLebcMgxKcO_VkC0C9Mo
Message-ID: <CA+55aFwGZm4+rdJ+xArhsVJ8P5gH3xxCfuoHibotr0Sik484=w@mail.gmail.com>
Subject: Re: autofs: make the autofsv5 packet file descriptor use a packetized pipe
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Michael Tokarev <mjt@tls.msk.ru>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
        Ian Kent <raven@themaw.net>, Thomas Meyer <thomas@m3y3r.de>,
        autofs@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Apr 29, 2012 at 5:28 PM, H. Peter Anvin <hpa@zytor.com> wrote:
>
>  do {
>    i = read(fd, buf, bytes);
>
>    if (i <= 0)
>      break;
>
>    buf = (char *)buf + i;
>    bytes -= i;
>  } while (bytes);
>
>  return bytes;

Ok, that should be fine. It will always get the full packet in one
read, so the short read case will never actually happen.

In fact, automount has this exact same pattern, except it calls the
function "fullread()".

The problem is only if it starts out by reading just the header of the
packet, and then reads the rest of the packet as a second read. *THAT*
won't work with the packetized pipe approach, because reading the
header of the packet will then discard the rest of it, and the second
read would try to read the *next* packet (which under many normal
loads won't even exist, of course).

                       Linus
