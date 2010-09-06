Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751293Ab0IFE4Z (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Sep 2010 00:56:25 -0400
Received: from mx4.wp.pl ([212.77.101.8]:59486 "EHLO mx4.wp.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751170Ab0IFE4Y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Sep 2010 00:56:24 -0400
X-Greylist: delayed 401 seconds by postgrey-1.27 at vger.kernel.org; Mon, 06 Sep 2010 00:56:24 EDT
Date: Mon, 06 Sep 2010 06:49:41 +0200
From: "zenek blus" <zenblu@wp.pl>
To: linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Calling vm_ops->open from a driver / reusing vma memory with
 vm_ops in other drivers
Message-ID: <4c8472e5c36922.92225774@wp.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Content-Disposition: inline
X-Mailer: Interfejs WWW nowej poczty Wirtualnej Polski
X-User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; pl; rv:1.9.2.8) Gecko/20100722 Firefox/3.6.8 (.NET CLR 3.5.30729)
Organization: Poznaj Poczte WP http://poczta.wp.pl/info-start.html
X-WP-IP: 210.94.41.89
X-WP-AV: skaner antywirusowy poczty Wirtualnej Polski S. A.
X-WP-SPAM: NO 0000000 [IfMk]                               
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,
I have the following problem:

Driver A has a custom mmap() implementation and assigns own vm_ops to a 
created vma.
The process which called mmap() passes the resulting userspace address 
to another
driver, driver B.

Driver B would then like to increment usage count on that memory for a 
duration of
some operation, i.e. call vm_ops->open(). It can find_vma() for the 
userspace address
it was given and call vm_ops->open() on found vma. It can then call 
vm_ops->close()
when finished.

The problem here though is that the found vm_area_struct (and the 
userspace address
for that matter) might not be valid anymore by the time driver B wants 
to call close().
There can be three possibilities here:

a) vm_area_struct used for open() is still present and can be reused for 
close()
- that looks ok, but storing a pointer to that vma is risky, driver B 
has no way to
know whether the pointer is still valid.

b) some other vm_area_structs are still present, but driver B has no 
knowledge
about them - so it does not have anything to pass to close().

c) no vm_area_structs remain, but since we called open() before, driver 
A is still
waiting for driver B to call close(); driver B does not have anything to 
pass to
close() and there is nothing in the system that could be passed to it 
anyway.

I don't suppose copying aside the whoe vm_area_struct used for open() 
call and passing
it back to close() is a good idea. Is there any way to do this? Or maybe 
I have it all
wrong?

Thank you,
Zenek


