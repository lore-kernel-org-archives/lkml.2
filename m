Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754832Ab1L2Qvs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Dec 2011 11:51:48 -0500
Received: from mgw2.diku.dk ([130.225.96.92]:60153 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754571Ab1L2Qvi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Dec 2011 11:51:38 -0500
From: Julia Lawall <Julia.Lawall@lip6.fr>
To: Liam Girdwood <lrg@ti.com>
Cc: kernel-janitors@vger.kernel.org,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>,
        alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org
Subject: [PATCH 0/10] use devm_ functions
Date: Thu, 29 Dec 2011 17:51:19 +0100
Message-Id: <1325177489-13815-1-git-send-email-Julia.Lawall@lip6.fr>
X-Mailer: git-send-email 1.7.3.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following is a semantic patch (http://coccinelle.lip6.fr/) that
introduces uses of various devm_ functions.  The main strategy is
illustrated by the rules prb, rem, bad and modif.  prb finds a probe
function that contains an allocation and possibly some frees of the
allocated data.  rem finds the corresponding remove function and checks
that it frees the allocated data.  bad checks whether the allocated data is
freed elsewhere.  When prb and rem are satisfied, ie data is allocated in
the probe function and freed in the remove function, and bad is not
satisfied, ie the data is not freed elsewhere, then modif renames the
allocation function and removes the freeing functions.

The remaining rules consider different variations on how the allocated data
may be referred to and do some cleanup.  Some cleanup must typically be
done by hand, such as removing empty labels and converting gotos to returns
when there is nothing to jump to.  The semantic patch also tries to clean
up unneeded calls to platform_set_drvdata, but the detection of
unneededness is not very sophisticated, and so it may delete calls that are
actually needed.  This cleanup could perhaps be better done by hand.

// requires the -in_place option
virtual after_start
virtual returned
virtual arg
virtual get

// ---------------------------------------------------------------------
// find functions

@plat depends on !after_start@
identifier i,pfn,rfn;
position p;
@@

struct platform_driver i@p = {
  .probe = pfn,
  .remove = (<+...rfn...+>),
};

// ---------------------------------------------------------------------
// set up iteration

@initialize:ocaml@

type ret = UseReturned | UseArg | UseGet

let add pfn rfn alloc free devm_alloc file rule =
   let it = new iteration() in
   it#set_files [file];
   it#add_virtual_rule After_start;
   (match rule with
      UseReturned -> it#add_virtual_rule Returned
    | UseArg -> it#add_virtual_rule Arg
    | UseGet -> it#add_virtual_rule Get);
   it#add_virtual_identifier Pfn pfn;
   it#add_virtual_identifier Rfn rfn;
   it#add_virtual_identifier Alloc alloc;
   it#add_virtual_identifier Free free;
   it#add_virtual_identifier Devm_alloc devm_alloc;
   it#register()

@script:ocaml@
pfn << plat.pfn;
rfn << plat.rfn;
p << plat.p;
@@

let file = (List.hd p).file in
add pfn rfn "kmalloc" "kfree" "devm_kzalloc" file UseReturned;
add pfn rfn "kzalloc" "kfree" "devm_kzalloc" file UseReturned;
add pfn rfn "ioremap" "iounmap" "devm_ioremap" file UseReturned;
add pfn rfn "ioremap_nocache" "iounmap" "devm_ioremap_nocache" file
   UseReturned;
add pfn rfn "request_irq" "free_irq" "devm_request_irq" file UseArg;
add pfn rfn "request_threaded_irq" "free_irq" "devm_request_threaded_irq" file
  UseArg;
add pfn rfn "request_region" "release_region" "devm_request_region" file
  UseGet;
add pfn rfn "request_mem_region" "release_mem_region"
  "devm_request_mem_region" file UseGet;
add pfn rfn "ioport_map" "ioport_unmap" "devm_ioport_map" file UseReturned

// ---------------------------------------------------------------------
// transform functions where free uses the result

@prb depends on returned@
identifier virtual.pfn,pdev,virtual.alloc,virtual.free;
expression x;
expression list args;
position p1,p2;
@@

pfn(struct platform_device *pdev) { ... when any
x = alloc@p1(args)
<... when strict
     when any
free@p2(x,...)
...>
}

@rem@
identifier virtual.rfn,virtual.free;
expression prb.x;
position p3;
@@

rfn(...) {
<+... when strict
free@p3(x,...)
...+>
}

@bad@
identifier virtual.free;
expression prb.x;
position p != {prb.p2,rem.p3};
@@

free@p(x,...)

@modif depends on rem && !bad@
expression x;
identifier prb.pdev,virtual.alloc,virtual.free,virtual.devm_alloc;
expression list args;
position prb.p1,prb.p2,rem.p3;
@@

(
- free@p2(...);
|
- free@p3(...);
|
  x =
- alloc@p1(
+ devm_alloc(&pdev->dev,
    args)
)

// ---------------------------------------------------------------------
// transform functions where free uses the first argument

@prbx depends on arg@
identifier virtual.pfn,pdev,virtual.alloc,virtual.free;
expression x;
expression list args;
position p1,p2;
@@

pfn(struct platform_device *pdev) { ... when any
alloc@p1(x,args)
<... when strict
     when any
free@p2(x,...)
...>
}

@remx@
identifier virtual.rfn, virtual.free;
expression prbx.x;
position p3;
@@

rfn(...) {
<+... when strict
free@p3(x,...)
...+>
}

@badx@
identifier virtual.free;
expression prbx.x;
position p != {prbx.p2,remx.p3};
@@

free@p(x,...)

@modifx depends on remx && !badx@
expression x;
identifier prbx.pdev,virtual.alloc,virtual.free,virtual.devm_alloc;
expression list args;
position prbx.p1,prbx.p2,remx.p3;
@@

(
- free@p2(...);
|
- free@p3(...);
|
- alloc@p1(
+ devm_alloc(&pdev->dev,
   x,args)
)

// ---------------------------------------------------------------------
// transform functions where free uses the result of platform_get_resource

@prbg depends on get@
identifier virtual.pfn,pdev,virtual.alloc,virtual.free;
expression x;
expression list args;
position p1,p2;
@@

pfn(struct platform_device *pdev) { ... when any
alloc@p1(x,args)
<... when strict
     when any
free@p2(x,...)
...>
}

@remg@
identifier virtual.rfn, virtual.free;
identifier y;
identifier pdev;
position p3;
@@

rfn(struct platform_device *pdev) {
<+... when strict
y = platform_get_resource(pdev, IORESOURCE_MEM, 0)
... when strict
free@p3(y->start,...)
...+>
}

@badg@
identifier virtual.free;
position p != {prbg.p2,remg.p3};
@@

free@p(...)

@modifg depends on remg && !badg@
expression x;
identifier prbg.pdev,virtual.alloc,virtual.free,virtual.devm_alloc;
expression list args;
position prbg.p1,prbg.p2,remg.p3;
@@

(
- free@p2(...);
|
- free@p3(...);
|
- alloc@p1(
+ devm_alloc(&pdev->dev,
   x,args)
)

// ---------------------------------------------------------------------
// cleanup, if the drvdata was only used to enable the free
// probably only relevant for kmalloc/kzalloc

@dclean depends on modif || modifx || modifg@
identifier virtual.rfn, pdev, i;
type T;
@@

rfn(struct platform_device *pdev) { ...
(
- T i = platform_get_drvdata(pdev);
|
- T i;
  ... when != i
- i = platform_get_drvdata(pdev);
)
... when != i
}

@useful depends on dclean@
@@

platform_get_drvdata(...)

@depends on dclean && !useful@
@@

- platform_set_drvdata(...);

@rclean depends on modif || modifx || modifg@
identifier virtual.rfn, pdev, i;
type T;
@@

rfn(struct platform_device *pdev) { ...
(
- T i = platform_get_resource(pdev,...);
|
- T i;
  ... when != i
- i = platform_get_resource(pdev,...);
)
... when != i
}

// ---------------------------------------------------------------------
// cleanup empty ifs, etc

@depends on modif || modifx || modifg@
identifier virtual.pfn;
@@

pfn(...) { <...
- if (...) {}
...> }

@depends on modif || modifx || modifg@
identifier virtual.rfn;
@@

rfn(...) { <...
- if (...) {}
...> }

@depends on modif || modifx || modifg@
identifier virtual.pfn;
expression ret,e;
@@

pfn(...) { <...
+ return
- ret =
 e;
- return ret;
...> }

@depends on modif || modifx || modifg@
identifier virtual.rfn;
expression ret,e;
@@

rfn(...) { <...
+ return
- ret =
 e;
- return ret;
...> }

