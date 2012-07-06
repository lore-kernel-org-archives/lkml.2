Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758263Ab2GFVDg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jul 2012 17:03:36 -0400
Received: from g4t0016.houston.hp.com ([15.201.24.19]:37811 "EHLO
	g4t0016.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753561Ab2GFVDe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jul 2012 17:03:34 -0400
Message-ID: <1341608402.16730.730.camel@misato.fc.hp.com>
Subject: Re: [PATCH] ACPI: Add ACPI CPU hot-remove support
From: Toshi Kani <toshi.kani@hp.com>
To: Khalid Aziz <khalid.aziz@hp.com>
Cc: Jiang Liu <liuj97@gmail.com>, lenb@kernel.org, linux-acpi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date: Fri, 06 Jul 2012 15:00:02 -0600
In-Reply-To: <4FF745F1.9030103@hp.com>
References: <1340981479-6521-1-git-send-email-toshi.kani@hp.com>
	  <4FF711DE.1030108@gmail.com> <1341602020.16730.695.camel@misato.fc.hp.com>
	 <4FF745F1.9030103@hp.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 (3.2.3-1.fc16) 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-07-06 at 14:09 -0600, Khalid Aziz wrote:
> On 07/06/2012 01:13 PM, Toshi Kani wrote:
> 
> >
> > For step 2) and 4), I am wondering if they are relevant to CPU hotplug
> > these days.  In ACPI namespace, a processor object represents a logical
> > processor (or a core when hyper-threading is disabled).  A physical
> > processor (i.e. a socket) usually has multiple cores, and memory
> > controller and bus interface are part of the socket functionality.
> > Hence, I think step 2) and 4) belong to socket-level hot-removal
> > operation, which can be implemented as container hot-remove when a
> > socket is represented with a container object.
> 
> What does it mean to eject just a core in that case? If there are seven
> other cores in the physical processor and you get a request to eject
> one core, what would you expect kernel to do - simply move all processes
> and interrupts off of that core, take it out of scheduling consideration
> and simply idle the core? If yes, how is that any different from simply
> offlining a core? 

Yes, offlining and eject are similar operations to a core as it alone
cannot be removed physically.  Ejecting a core is a logical eject
operation, which updates the status (_STA) of the object in ACPI after
offlining.  The difference from the offlining is that the ejected core
is no longer assigned to the partition.  Here is one example.  Say, a
core is assigned to a guest partition as a dedicated resource (ex. 100%
of its CPU time is bound to the partition).  Offlining this core saves
the power-consumption, but this core is still bound to the partition.
Ejecting the core removes it from the partition (logically), and allows
it to be assigned to other partition as a dedicated resource with
hot-add.


> If you are ejecting individual cores at a time, do you
> keep track of how many you have ejected and then eject the entire physical
> CPU along with memory and IOH associated with the socket when the last
> core is ejected?

It depends on the firmware implementation, but typically the answer is
no.  _EJ0 of a core object only removes the associated core object.  It
will require a separate socket hot-remove request to eject the
socket-level resources.  That is, the OS may not call _EJ0 of a socket
object from the core hot-remove operation just because all children
cores are removed. 

Thanks,
-Toshi



