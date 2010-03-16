Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966321Ab0CPOif (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Mar 2010 10:38:35 -0400
Received: from mail-fx0-f219.google.com ([209.85.220.219]:42080 "EHLO
	mail-fx0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966305Ab0CPOie (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Mar 2010 10:38:34 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding
         :content-disposition:message-id;
        b=lVA3jDU2spE1x0EdE2uN8L1kDl7RsuCrSWUZ70mLHgBnFiTS/0OiBRH7/W3jcqi01S
         haxHzc8W0dYeIb1Bx8JuC3fmUxmwlcfcL6x6xiq3gkQC20257tUJypcS2F/svdZrxAb2
         VfvXzLSk+eqrFUA0FKSzyJ0pOS8EhP3wLYDbE=
From: Denys Vlasenko <vda.linux@googlemail.com>
To: Tejun Heo <tj@kernel.org>
Subject: Re: ATA 4 KiB sector issues.
Date: Tue, 16 Mar 2010 15:38:26 +0100
User-Agent: KMail/1.8.2
Cc: James Bottomley <James.Bottomley@suse.de>, Arnd Bergmann <arnd@arndb.de>,
       "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>,
       lkml <linux-kernel@vger.kernel.org>,
       Daniel Taylor <Daniel.Taylor@wdc.com>, Jeff Garzik <jeff@garzik.org>,
       Mark Lord <kernel@teksavvy.com>, tytso@mit.edu,
       "H. Peter Anvin" <hpa@zytor.com>, hirofumi@mail.parknet.co.jp,
       Andrew Morton <akpm@linux-foundation.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, irtiger@gmail.com,
       Matthew Wilcox <matthew@wil.cx>, aschnell@suse.de, knikanth@suse.de,
       jdelvare@suse.de
References: <4B947393.2050002@kernel.org> <1268745897.21384.14.camel@mulgrave.site> <4B9F8E1A.2020608@kernel.org>
In-Reply-To: <4B9F8E1A.2020608@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201003161538.27015.vda.linux@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 16 March 2010 14:56, Tejun Heo wrote:
> Hello, James.
> 
> On 03/16/2010 10:24 PM, James Bottomley wrote:
> > For msdos labels, it's embedded in the label ... for all other labels,
> > it's made up on the spot.
> 
> Where in the label?

The "end of partition" is expected to be at the last head and sector.
Of course this heuristic fails if there are more than one primary
partition and they have differing last head and sector.

But on most "sanely" partitioned disks they are the same:

Disk /dev/sda: 255 heads, 63 sectors, 36481 cylinders

Nr AF  Hd Sec  Cyl  Hd Sec  Cyl      Start       Size ID
 1 00   1   1    0 254  63  850         63   13671252 0b
 2 80   0   1  851 254  63 1023   13671315  572395950 05
 3 00   0   0    0   0   0    0          0          0 00
 4 00   0   0    0   0   0    0          0          0 00
 5 00   1   1  851 254  63  972         63    1959867 83
 6 00   1   1  973 254  63 1023         63   31246362 83
 7 00 254  63 1023 254  63 1023         63  195318207 83
 8 00 254  63 1023 254  63 1023         63  343871262 83
                   ^^^  ^^

Which suggests another idea how to align a partition:
since there is no requirement on the partition *start*,
we don't have to start at head1,sector1 or head0,sector1

In the example above, 1st partition might be modified to start
at head1,sector2, IOW, LBA 64, thus making it 32k aligned.

As long as partition *ends* adhere to the convention
of being exactly at last_head,last_sector, nothing should break.
-- 
vda
