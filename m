Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757651Ab2EGWpF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 May 2012 18:45:05 -0400
Received: from mx1.redhat.com ([209.132.183.28]:11820 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756814Ab2EGWpD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 May 2012 18:45:03 -0400
Subject: Re: x86: runtime waring in pcibios_fwaddrmap_lookup
From: Myron Stowe <mstowe@redhat.com>
To: Meelis Roos <mroos@linux.ee>
Cc: Bjorn Helgaas <bhelgaas@google.com>,
        Linux Kernel list <linux-kernel@vger.kernel.org>,
        Jesse Barnes <jbarnes@virtuousgeek.org>
In-Reply-To: <1335905694.2386.138.camel@zim.stowe>
References: <alpine.SOC.1.00.1204122238400.16365@math.ut.ee>
	 <CAErSpo6YnzywdjTTVdVEHj_E-B0ARBpZ+fiy29Rv==fO6m9-FA@mail.gmail.com>
	 <1335557685.2386.62.camel@zim.stowe>
	 <alpine.SOC.1.00.1204280819270.14507@math.ut.ee>
	 <1335905694.2386.138.camel@zim.stowe>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 07 May 2012 16:44:58 -0600
Message-ID: <1336430699.2427.117.camel@zim.stowe>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-05-01 at 14:54 -0600, Myron Stowe wrote:
> On Sat, 2012-04-28 at 08:36 +0300, Meelis Roos wrote:
> > > So, somehow, your system hit the assertion (WARN_ON) in
> > > pcibios_fwaddrmap_lookup().  From the dmesg log you provided I can see
> > > why pcibios_save_fw_addr() was called - there is a resource collision
> > > with the video device's GART - but what I don't understand is how the
> > > assertion is being triggered.
> > > 
> > > There are only two callers of pcibios_fwaddrmap_lookup()
> > > (see ./arch/x86/pci/i386.c:: pcibios_save_fw_addr(), and
> > > pcibios_retrieve_fw_addr()) and both of those are acquiring the lock
> > > before making the call - so triggering the assertion just doesn't seem
> > > possible but obviously it is getting triggered.
> > > 
> > > I don't have any ideas currently but do have some questions that
> > > hopefully will start to enlighten us.
> > > 
> > >         Does your system encounter this consistently upon every boot or
> > >         is it hit intermittently?
> > 
> > Every time.
> > 
> > >         Do you know of any kernel versions that do not encounter it?
> > 
> > Checked my logs, no kernel up to 3.3.0 included gave it, next tested 
> > kernel was 3.4.0-rc2 and that had the warning and every kernel since has 
> > had it.
> > 
> > >         Are you running a para-virtualized kernel?
> > 
> > No.
> 
> Thanks for the quick response Meelis (unlike myself; I've been consumed
> with a hard deadline task recently - sorry).
> 
> I got together with Bjorn and after showing him the paths, and locking,
> he also did not see how we could be hitting the WARN_ON.  I would like
> to take advantage of your system since it encounters this consistently
> but really have no idea how to progress currently.  I'll query a couple
> of my colleagues for suggestions.  In the meantime, if anyone else -
> Jesse - has any ideas, please speak up.

Ok, no-one is speaking up with any ideas so let's try a brute force
approach and see if that yields any insight into this situation.  When
you get time, would you please apply the following patch and run with
the "debug" kernel option capturing the boot log ('dmesg').

Thanks,
 Myron
> 
> As for you noticing this after 3.3.0 that makes sense as the WARN_ON was
> added with 3.3.0.
> 
> Myron

commit 0d29ac2494a67823aeff25d7476facea0d3ccc40
Author: Myron Stowe <myron.stowe@redhat.com>
Date:   Mon May 7 10:22:53 2012 -0600

    This patch instruments the PCI BAR save and restore paths.  It is
    intended for use in attempting to identify, and isolate, the
    WARN_ON assertion that is being encountered in
    'pcibios_fwaddrmap_lookup()':
      https://lkml.org/lkml/2012/4/12/576
    
    Instrumentation only - not intended for submittal upstream.

diff --git a/arch/x86/pci/i386.c b/arch/x86/pci/i386.c
index 831971e..538bb49 100644
--- a/arch/x86/pci/i386.c
+++ b/arch/x86/pci/i386.c
@@ -57,6 +57,8 @@ static struct pcibios_fwaddrmap *pcibios_fwaddrmap_lookup(struct pci_dev *dev)
 {
        struct pcibios_fwaddrmap *map;
 
+       if(!spin_is_locked(&pcibios_fwaddrmap_lock))
+               dump_stack();
        WARN_ON(!spin_is_locked(&pcibios_fwaddrmap_lock));
 
        list_for_each_entry(map, &pcibios_fwaddrmappings, list)
@@ -72,10 +74,12 @@ pcibios_save_fw_addr(struct pci_dev *dev, int idx, resource_size_t fw_addr)
        unsigned long flags;
        struct pcibios_fwaddrmap *map;
 
+       dump_stack();
        spin_lock_irqsave(&pcibios_fwaddrmap_lock, flags);
        map = pcibios_fwaddrmap_lookup(dev);
        if (!map) {
                spin_unlock_irqrestore(&pcibios_fwaddrmap_lock, flags);
+               dump_stack();
                map = kzalloc(sizeof(*map), GFP_KERNEL);
                if (!map)
                        return;
@@ -84,11 +88,13 @@ pcibios_save_fw_addr(struct pci_dev *dev, int idx, resource_size_t fw_addr)
                map->fw_addr[idx] = fw_addr;
                INIT_LIST_HEAD(&map->list);
 
+               dump_stack();
                spin_lock_irqsave(&pcibios_fwaddrmap_lock, flags);
                list_add_tail(&map->list, &pcibios_fwaddrmappings);
        } else
                map->fw_addr[idx] = fw_addr;
        spin_unlock_irqrestore(&pcibios_fwaddrmap_lock, flags);
+       dump_stack();
 }
 
 resource_size_t pcibios_retrieve_fw_addr(struct pci_dev *dev, int idx)
@@ -97,11 +103,13 @@ resource_size_t pcibios_retrieve_fw_addr(struct pci_dev *dev, int idx)
        struct pcibios_fwaddrmap *map;
        resource_size_t fw_addr = 0;
 
+       dump_stack();
        spin_lock_irqsave(&pcibios_fwaddrmap_lock, flags);
        map = pcibios_fwaddrmap_lookup(dev);
        if (map)
                fw_addr = map->fw_addr[idx];
        spin_unlock_irqrestore(&pcibios_fwaddrmap_lock, flags);
+       dump_stack();
 
        return fw_addr;
 }
@@ -111,6 +119,7 @@ static void pcibios_fw_addr_list_del(void)
        unsigned long flags;
        struct pcibios_fwaddrmap *entry, *next;
 
+       dump_stack();
        spin_lock_irqsave(&pcibios_fwaddrmap_lock, flags);
        list_for_each_entry_safe(entry, next, &pcibios_fwaddrmappings, list) {
                list_del(&entry->list);
@@ -118,6 +127,7 @@ static void pcibios_fw_addr_list_del(void)
                kfree(entry);
        }
        spin_unlock_irqrestore(&pcibios_fwaddrmap_lock, flags);
+       dump_stack();
 }
 
 static int


