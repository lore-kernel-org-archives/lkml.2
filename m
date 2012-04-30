Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754803Ab2D3A3V (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Apr 2012 20:29:21 -0400
Received: from terminus.zytor.com ([198.137.202.10]:55830 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754581Ab2D3A3U (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Apr 2012 20:29:20 -0400
Message-ID: <4F9DDCB6.1070908@zytor.com>
Date: Sun, 29 Apr 2012 17:28:38 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120329 Thunderbird/11.0.1
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Michael Tokarev <mjt@tls.msk.ru>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
        Ian Kent <raven@themaw.net>, Thomas Meyer <thomas@m3y3r.de>,
        autofs@vger.kernel.org
Subject: Re: autofs: make the autofsv5 packet file descriptor use a packetized
 pipe
References: <20120429205429.63CCD7C0064@ra.kernel.org> <4F9DD994.70202@zytor.com> <CA+55aFy72rPMq3M2_PU0ue45Fb38_Effrfhu2uOpdVXt9H1XOg@mail.gmail.com>
In-Reply-To: <CA+55aFy72rPMq3M2_PU0ue45Fb38_Effrfhu2uOpdVXt9H1XOg@mail.gmail.com>
X-Enigmail-Version: 1.4.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/29/2012 05:25 PM, Linus Torvalds wrote:
> On Sun, Apr 29, 2012 at 5:15 PM, H. Peter Anvin <hpa@zytor.com> wrote:
>>
>> I just looked at am-utils; am-utils *does* use autofs v5, and *will*
>> loop back and read more data on a short read.
> 
> Can you point to the sources?
> 
> If it's "short read" as in "I didn't get as much as I expected", that's fine.
> 
> If it is "short read" as in "I don't even try to read 300 bytes, I
> read it in 8-byte chunks", we're screwed.
> 

git://git.fsl.cs.sunysb.edu/am-utils-6.2.git
conf/autofs/autofs_linux.c

static ssize_t
autofs_get_pkt(int fd, void *buf, size_t bytes)
{
  ssize_t i;

  do {
    i = read(fd, buf, bytes);

    if (i <= 0)
      break;

    buf = (char *)buf + i;
    bytes -= i;
  } while (bytes);

  return bytes;
}

...

#if AUTOFS_MAX_PROTO_VERSION >= 5
    if (fh->version < 5) {
      len = sizeof(p.pkt);
    } else {
      len = sizeof(p.pkt5);
    }
#else
    len = sizeof(p.pkt);
#endif /* AUTOFS_MAX_PROTO_VERSION >= 5 */

    if (autofs_get_pkt(fh->fd, &p, len))
      continue;
