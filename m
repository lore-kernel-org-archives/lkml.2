Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754531Ab1DGJ4u (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Apr 2011 05:56:50 -0400
Received: from mo-p00-ob.rzone.de ([81.169.146.161]:16134 "EHLO
	mo-p00-ob.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753216Ab1DGJ4t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Apr 2011 05:56:49 -0400
X-RZG-AUTH: :P2EQZWCpfu+qG7CngxMFH1J+zrwiavkK6tmQaLfmztM8TOFIiy0PGjDB
X-RZG-CLASS-ID: mo00
Date: Thu, 7 Apr 2011 11:56:47 +0200
From: Olaf Hering <olaf@aepfle.de>
To: linux-kernel@vger.kernel.org, kexec@lists.infradead.org
Subject: dynamic oldmem in kdump kernel
Message-ID: <20110407095646.GA30788@aepfle.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Recently kdump for pv-on-hvm Xen guests was implemented by me.

One issue remains:
The xen_balloon driver in the guest frees guest pages and gives them
back to the hypervisor. These pages are marked as mmio in the
hypervisor. During a read of such a page via the /proc/vmcore interface
the hypervisor calls the qemu-dm process. qemu-dm tries to map the page,
this attempt fails because the page is not backed by ram and 0xff is
returned. All this generates high load in dom0 because the reads come
as 8byte requests.

There seems to be no way to make the crash kernel aware of the state of
individual pages in the crashed kernel, it is not aware of memory
ballooning. And doing that from within the "kernel to crash" seems error
prone. Since over time the fragmentation will increase, it would be best
if the crash kernel itself queries the state of oldmem pages. 

If copy_oldmem_page() would call a function, a hook, provided by the Xen
pv-on-hvm drivers to query if the pfn to read from is really backed by
ram the load issue could be avoided. Unfortunately, even Xen needs to
get a new interface to query the state of individual hvm guest pfns for
the purpose mentioned above.



Another issue, slightly related, is memory hotplug.
How is this currently handled for kdump?  Is there code which
automatically reconfigures the kdump kernel with the new memory ranges?


Olaf

