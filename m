Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751601Ab2GUQJA (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Jul 2012 12:09:00 -0400
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:45184 "EHLO
	out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751315Ab2GUQI6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Jul 2012 12:08:58 -0400
X-Sasl-enc: QSw9HtogQuE83l07QI4U1pY+zPX8UECEOCHOLafnwbrF 1342886938
Date: Sat, 21 Jul 2012 13:08:55 -0300
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Colin Cross <ccross@android.com>
Cc: Richard Purdie <richard.purdie@linuxfoundation.org>,
        Greg KH <gregkh@linuxfoundation.org>,
        lkml <linux-kernel@vger.kernel.org>, Bryan Wu <bryan.wu@canonical.com>
Subject: Re: sysfs permissions on dynamic attributes (led delay_on and
 delay_off)
Message-ID: <20120721160855.GB7565@khazad-dum.debian.net>
References: <CAMbhsRTX=t4UMfmrJRyXidSTWXvaC5L9aFdTFL03wYYKrUE5qw@mail.gmail.com>
 <20120721040816.GA7313@kroah.com>
 <1342856010.21788.47.camel@ted>
 <CAMbhsRREVcqf+pnamY62wGcd2mBif8W8_CRXdJQCQvL14Dy3Eg@mail.gmail.com>
 <1342869707.21788.50.camel@ted>
 <CAMbhsRQ2EPEW+=0bhE6N9-dr44H8G_gzQ7h5LqOp7Lntr2RhTg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAMbhsRQ2EPEW+=0bhE6N9-dr44H8G_gzQ7h5LqOp7Lntr2RhTg@mail.gmail.com>
X-GPG-Fingerprint: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F
 1CDB 0FE3
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 21 Jul 2012, Colin Cross wrote:
> The delay_on and delay_off files could easily override the values from
> the trigger.
> 
> Sending a KOBJ_CHANGE uevent is not a great solution, it's still
> horribly racy in userspace.  This script would never work reliably:
> echo timer > trigger
> echo 1000 > delay_on
> echo 1000 > delay_off
> echo 255 > brightness

Yes, and the proper fix is to instead use a fully async userspace based on
uevent callbacks.  Nasty as all hell.  Or the quick fix, which is to wait
for the system to settle after every sysfs operation that could create new
sysfs nodes.

You could make sure that (1) no sysfs operation will return control to
userspace until it is complete, so you'd have all new sysfs nodes available
at the time the first echo returns [I believe it already works like that],
and (2) either enhance sysfs to create nodes with the desired ownership and
permissions -- which requires feeding policy rules to it beforehand at the
very least; or do it as whichever priviledged user/group has default write
access to sysfs nodes.

This is a general problem.  I have no idea whether Richard will allow the
triggers hack to work around it or not, and I really don't care.  But the
bad sideffects of the hack that he pointed out are all very true, and far
reaching in time.

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
