Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755812Ab2CDWKH (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Mar 2012 17:10:07 -0500
Received: from mail4-relais-sop.national.inria.fr ([192.134.164.105]:7070 "EHLO
	mail4-relais-sop.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753721Ab2CDWKD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Mar 2012 17:10:03 -0500
X-IronPort-AV: E=Sophos;i="4.73,531,1325458800"; 
   d="scan'208";a="134319034"
Date: Sun, 4 Mar 2012 23:09:59 +0100 (CET)
From: Julia Lawall <julia.lawall@lip6.fr>
X-X-Sender: jll@hadrien
To: Dan Carpenter <dan.carpenter@oracle.com>
cc: Lionel Debroux <lionel_debroux@yahoo.fr>, linux-kernel@vger.kernel.org,
        linux-edac@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [PATCH] edac: move const pci_device_id tables from __devinitdata
 to __devinitconst.
In-Reply-To: <20120227061300.GC4763@mwanda>
Message-ID: <alpine.DEB.2.02.1203042256550.2919@hadrien>
References: <791782.71473.bm@smtp128.mail.ukl.yahoo.com> <20120227061300.GC4763@mwanda>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 27 Feb 2012, Dan Carpenter wrote:

> On Sun, Feb 26, 2012 at 09:15:29PM +0100, Lionel Debroux wrote:
>> Based on PaX and earlier work by Andi Kleen.
>>
>> Patch against current Linus tree.
>>
>
> Always write patches against linux-next.  We can't apply this.
>
> I wonder if we could make a coccinelle script for this.

I made two semantic patches for this.  Coccinelle can't match things like 
__devinitdata, so the first one is completely unsafe:

@@
identifier id;
declarer name DEFINE_PCI_DEVICE_TABLE;
@@

-const struct pci_device_id id[] =
+DEFINE_PCI_DEVICE_TABLE(id) =
   { ... };

In the second version, I try to figure out whether __devinitdata could be 
there, whether it is or not.  This only allows the array to appear as the 
argument of MODULE_DEVICE_TABLE or in the id_table of a static pci_driver 
structure.  This structure, which I call pcidr, can furthermore only be 
used in function calls of the form f(&pcidr) in the module_init and 
module_exit.  I could have specified the function to be 
pci_register_driver or pci_unregister_driver, but I saw one example that 
had something else in the register case, so I decided to be more general.

The simple semantic patch above affects 168 files, and the safer one below 
affects 145.  On the other hand, the latter is missing some cases where 
the structure is annotated __devinitdata, so my safe strategy is too 
conservative.

In any case, one would have to check the results carefully.

Unfortunately, both semantic patches only work with the soon to be 
released version 1.0.0-rc12.

I don't have time now to check the results and submit patches, but if 
someone else wants to, I could provide the actual results.

julia

-----

The safe(r) semantic patch:

@r@
identifier id;
@@

const struct pci_device_id id[] = { ... };

@one@
expression pci;
identifier r.id;
position p1;
declarer name MODULE_DEVICE_TABLE;
@@

MODULE_DEVICE_TABLE(pci, id@p1);

@str@
identifier pcidr;
identifier r.id;
position pstr;
@@

static struct pci_driver pcidr = {
         .id_table       = id@pstr,
};

@ini@
identifier init;
declarer name module_init;
@@

module_init(init);

@two@
identifier ini.init;
identifier reg;
identifier str.pcidr;
position p2;
@@

init(...) { <... reg(&pcidr@p2) ...> }

@ex@
identifier exit;
declarer name module_exit;
@@

module_exit(exit);

@three@
identifier ex.exit;
identifier unreg;
identifier str.pcidr;
position p3;
@@

exit(...) { <... unreg(&pcidr@p3) ...> }

@badstr expression@
identifier str.pcidr;
position p != {two.p2,three.p3};
@@

pcidr@p

@badid expression@
identifier r.id;
position p != {one.p1,str.pstr};
@@

id@p

@depends on !badstr && !badid@
identifier r.id;
declarer name DEFINE_PCI_DEVICE_TABLE;
@@

-const struct pci_device_id id[] =
+DEFINE_PCI_DEVICE_TABLE(id) =
  { ... };
