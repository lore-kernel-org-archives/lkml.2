Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754247Ab0CVHWL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Mar 2010 03:22:11 -0400
Received: from mga10.intel.com ([192.55.52.92]:12543 "EHLO
	fmsmga102.fm.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754164Ab0CVHWJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Mar 2010 03:22:09 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.51,285,1267430400"; 
   d="scan'208";a="782761270"
Subject: Re: [PATCH] Enhance perf to collect KVM guest os statistics from
 host side
From: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Avi Kivity <avi@redhat.com>,
       Sheng Yang <sheng@linux.intel.com>, linux-kernel@vger.kernel.org,
       kvm@vger.kernel.org, Marcelo Tosatti <mtosatti@redhat.com>,
       oerg Roedel <joro@8bytes.org>, Jes Sorensen <Jes.Sorensen@redhat.com>,
       Gleb Natapov <gleb@redhat.com>, Zachary Amsden <zamsden@redhat.com>,
       zhiteng.huang@intel.com, Fr??d??ric Weisbecker <fweisbec@gmail.com>,
       Arnaldo Carvalho de Melo <acme@redhat.com>
In-Reply-To: <20100319082122.GE12576@elte.hu>
References: <1268717232.2813.36.camel@localhost>
	 <1268969929.2813.184.camel@localhost>  <20100319082122.GE12576@elte.hu>
Content-Type: text/plain; charset="ISO-8859-1"
Date: Mon, 22 Mar 2010 15:24:47 +0800
Message-Id: <1269242687.2078.25.camel@ymzhang.sh.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.0 (2.28.0-2.fc12) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-03-19 at 09:21 +0100, Ingo Molnar wrote:
> Nice progress!
> 
> This bit:
> 
> > 1) perf kvm top
> > [root@lkp-ne01 norm]# perf kvm --host --guest --guestkallsyms=/home/ymzhang/guest/kallsyms
> > --guestmodules=/home/ymzhang/guest/modules top
> 

> Will be really be painful to developers - to enter that long line while we 
> have these things called 'computers' that ought to reduce human work. Also, 
> it's incomplete, we need access to the guest system's binaries to do ELF 
> symbol resolution and dwarf decoding.
Yes, I agree with you and Avi that we need the enhancement be user-friendly.
One of my start points is to keep the tool having less dependency on
other components. Admin/developers could write script wrappers quickly if
perf has parameters to support the new capability.


> 
> So we really need some good, automatic way to get to the guest symbol space, 
> so that if a developer types:
> 
>    perf kvm top
> 
> Then the obvious thing happens by default. (which is to show the guest 
> overhead)
> 
> There's no technical barrier on the perf tooling side to implement all that: 
> perf supports build-ids extensively and can deal with multiple symbol spaces - 
> as long as it has access to it. The guest kernel could be ID-ed based on its 
> /sys/kernel/notes and /sys/module/*/notes/.note.gnu.build-id build-ids.
I tried sshfs quickly. sshfs could mount root filesystem of guest os nicely.
I could access the files quickly. However, it doesn't work when I access
/proc/ and /sys/ because sshfs/scp depend on file size while the sizes of most
files of /proc/ and /sys/ are 0.


> 
> So some sort of --guestmount option would be the natural solution, which 
> points to the guest system's root: and a Qemu enumeration of guest mounts 
> (which would be off by default and configurable) from which perf can pick up 
> the target guest all automatically. (obviously only under allowed permissions 
> so that such access is secure)
If sshfs could access /proc/ and /sys correctly, here is a design:
--guestmount points to a directory which consists of a list of sub-directories.
Every sub-directory's name is just the qemu process id of guest os. Admin/developer
mounts every guest os instance's root directory to corresponding sub-directory.

Then, perf could access all files. It's possible because guest os instance
happens to be multi-threading in a process. One of the defects is the accessing to
guest os becomes slow or impossible when guest os is very busy.


> 
> This would allow not just kallsyms access via $guest/proc/kallsyms but also 
> gives us the full space of symbol features: access to the guest binaries for 
> annotation and general symbol resolution, command/binary name identification, 
> etc.
> 
> Such a mount would obviously not broaden existing privileges - and as an 
> additional control a guest would also have a way to indicate that it does not 
> wish a guest mount at all.
> 
> Unfortunately, in a previous thread the Qemu maintainer has indicated that he 
> will essentially NAK any attempt to enhance Qemu to provide an easily 
> discoverable, self-contained, transparent guest mount on the host side.
> 
> No technical justification was given for that NAK, despite my repeated 
> requests to particulate the exact security problems that such an approach 
> would cause.
> 
> If that NAK does not stand in that form then i'd like to know about it - it 
> makes no sense for us to try to code up a solution against a standing 
> maintainer NAK ...
> 
> The other option is some sysadmin level hackery to NFS-mount the guest or so. 
> This is a vastly inferior method that brings us back to the absymal usability 
> levels of OProfile:
> 
>  1) it wont be guest transparent
>  2) has to be re-done for every guest image. 
>  3) even if packaged it has to be gotten into every. single. Linux. distro. separately.
>  4) old Linux guests wont work out of box
> 
> In other words: it's very inconvenient on multiple levels and wont ever happen 
> on any reasonable enough scale to make a difference to Linux.
> 
> Which is an unfortunate situation - and the ball is on the KVM/Qemu side so i 
> can do little about it.
> 
> Thanks,
> 
> 	Ingo


