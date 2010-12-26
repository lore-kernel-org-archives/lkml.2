Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752618Ab0LZTmD (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Dec 2010 14:42:03 -0500
Received: from nm25.bullet.mail.ac4.yahoo.com ([98.139.52.222]:46277 "HELO
	nm25.bullet.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752508Ab0LZTmB convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Dec 2010 14:42:01 -0500
X-Yahoo-Newman-Property: ymail-3
X-Yahoo-Newman-Id: 75918.4273.bm@omp1025.mail.ac4.yahoo.com
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=Message-ID:X-YMail-OSG:Received:X-Mailer:Date:From:Subject:To:Cc:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding;
  b=zTFrYLK55qJDBKhxXWmCkrEQM/Z/mE102oZg5+5H2QWjTtc061FjnJ3m6tjQIEbBbOVz4YwkyYz+xLGjvm+VxeZXRG8K8GYCzbppCJps554Kr3c31fdbNXEPD50VnHJ5WTtTGXKBTdTxmK8Cu81GhmaD5KCyhycoO2tFH+xDHvc=;
Message-ID: <915580.52826.qm@web65716.mail.ac4.yahoo.com>
X-YMail-OSG: yvMDhHwVM1maDlc2XFrX2tcy2WvT8_CnGwssrBDGdUqj7sv
 DOfXfvL.IKeaZ3mnfyxed3JHBo1A7uZT3dh5OAyebl.9LwdUnL8nA8i346tL
 eJKa5N6uUttnjxh1DBUoLNKJC7L4kTELgS.f6vou.UdumkHte_Kce2sItlRx
 rxVeOKLEMmYTrwef_YV1M7zywvp5yuMCkRbBb27pd_YcYEPBvao_8wscUHcp
 bci6Mdy1lXNnu73xEA1Eq4ftSSjrpIyhSVMiZWR4ofPCH0Jauy62mmkNN5j2
 4c27Lhh9IvF961gO3S_2sZ3tW22q4TLRvsW92AbYVfvv6XqDABUP8bK.RYsr
 Xcy11cajKAtxfQrO9WqaNzD.TmN817zvPZZSHB4A1hiIdb5sXVWQR
X-Mailer: YahooMailClassic/11.4.20 YahooMailWebService/0.8.107.285259
Date: Sun, 26 Dec 2010 11:41:59 -0800 (PST)
From: Tsozik <tsozik@yahoo.com>
Subject: Re: [PATCH 1/1] mct_u232: IOCTL implementation
To: Pete Zaitcev <zaitcev@redhat.com>
Cc: Greg Kroah-Hartman <gregkh@suse.de>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org
In-Reply-To: <20101226104905.6801612f@lembas.zaitcev.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pete,

Many thanks for your comment/concern. I borrowed an TIOCGICOUNT implementation from usb/serial/io_ti.c:

        case TIOCGICOUNT:
                dbg("%s - (%d) TIOCGICOUNT RX=%d, TX=%d", __func__,
                     port->number, edge_port->icount.rx, edge_port->icount.tx);
                if (copy_to_user((void __user *)arg, &edge_port->icount,
                                sizeof(edge_port->icount)))
                        return -EFAULT;
                return 0;
        }

There are 2 similar TIOCGICOUNT implementations listed in

ark3116.c
io_edgeport.c
io_ti.c
mos7720.c
mos7840.c
ti_usb_3410_5052.c

files under usb/serial/ directory. One based on io_ti.c and another based on io_edgeport.c. I borrowed one from io_ti.c, since it looked more effecient to me. I searched for any mention of get_icount function under linux-2.6.35 and didn't find any file which declared or called this function:

[vtsozik@SR71 linux-2.6.35]$ find . -type f -name '*.[c,h]' | xargs grep get_icount
[vtsozik@SR71 linux-2.6.35]$

I'm wondering if you could give me a bit more information on this. Otherwise I would really prefer to proceed with something that already exists and tested. If by some reason you believe that alternative implementation from io_edgeport.c (please see code snippet below) should be used please let me know. Again I didn't see any reason for extra copy.

        case TIOCGICOUNT:
                cnow = edge_port->icount;
                memset(&icount, 0, sizeof(icount));
                icount.cts = cnow.cts;
                icount.dsr = cnow.dsr;
                icount.rng = cnow.rng;
                icount.dcd = cnow.dcd;
                icount.rx = cnow.rx;
                icount.tx = cnow.tx;
                icount.frame = cnow.frame;
                icount.overrun = cnow.overrun;
                icount.parity = cnow.parity;
                icount.brk = cnow.brk;
                icount.buf_overrun = cnow.buf_overrun;

                dbg("%s (%d) TIOCGICOUNT RX=%d, TX=%d",
                                __func__,  port->number, icount.rx, icount.tx);
                if (copy_to_user((void __user *)arg, &icount, sizeof(icount)))
                        return -EFAULT;
                return 0;
        }

Thank you in advance,
Vadim.

--- On Sun, 12/26/10, Pete Zaitcev <zaitcev@redhat.com> wrote:

> From: Pete Zaitcev <zaitcev@redhat.com>
> Subject: Re: [PATCH 1/1] mct_u232: IOCTL implementation
> To: "Tsozik" <tsozik@yahoo.com>
> Cc: "Greg Kroah-Hartman" <gregkh@suse.de>, linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
> Date: Sunday, December 26, 2010, 12:49 PM
> On Sat, 25 Dec 2010 21:39:39 -0800
> (PST)
> Tsozik <tsozik@yahoo.com>
> wrote:
> 
> > +++ mct_u232.c  2010-12-25 21:44:57.714640343
> -0500
> > +static int  mct_u232_ioctl(struct tty_struct
> *tty, struct file *file,
> > +             
>           unsigned int cmd,
> unsigned long arg)
> > +{
> > +       case TIOCGICOUNT:
> > +             
>   dbg("%s - (%d) TIOCGICOUNT RX=%d, TX=%d", __func__,
> > +             
>       port->number,
> mct_u232_port->icount.rx, mct_u232_port->icount.tx);
> > +             
>   if (copy_to_user((void __user *)arg,
> &mct_u232_port->icount,
> > +             
>       sizeof(mct_u232_port->icount)))
> > +             
>           return -EFAULT;
> 
> This looks suspicious. Didn't we relocate the machinery for
> TIOCGICOUNT
> into a generic place? Please examine how ->get_icount
> works before
> hand-rolling the ioctl.
> 
> -- Pete
> 


      
