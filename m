Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756316Ab0CQWrT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Mar 2010 18:47:19 -0400
Received: from cantor.suse.de ([195.135.220.2]:34454 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756220Ab0CQWrR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Mar 2010 18:47:17 -0400
Subject: Re: [PATCH 23/42] KVM: Activate Virtualization On Demand
Mime-Version: 1.0 (Apple Message framework v1077)
Content-Type: text/plain; charset=us-ascii
From: Alexander Graf <agraf@suse.de>
In-Reply-To: <20100317224002.GA5156@Localhorst.asterix.local>
Date: Wed, 17 Mar 2010 23:47:14 +0100
Cc: Avi Kivity <avi@redhat.com>, linux-kernel@vger.kernel.org,
       kvm@vger.kernel.org
Content-Transfer-Encoding: 8BIT
Message-Id: <59B2FA1C-035D-41BC-8359-65BDE8D541FE@suse.de>
References: <1258373983-8693-1-git-send-email-avi@redhat.com> <1258373983-8693-24-git-send-email-avi@redhat.com> <4BA1504A.3090801@dieterries.net> <808FF008-53B9-4271-904C-117A24ADF18C@suse.de> <20100317224002.GA5156@Localhorst.asterix.local>
To: Dieter Ries <mail@dieterries.net>
X-Mailer: Apple Mail (2.1077)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On 17.03.2010, at 23:40, Dieter Ries wrote:

> On Wed, Mar 17, 2010 at 11:02:40PM +0100, Alexander Graf wrote:
>> On 17.03.2010, at 22:57, Dieter Ries wrote:
>>> Hi,
>>> 
>>> This is breaking KVM on my Phenom II X4 955.
>>> 
>>> When I start kvm I get this on the terminal:
>>> 
>>> kvm_create_vm: Device or resource busy
>>> Could not initialize KVM, will disable KVM support
>>> 
>>> And in dmesg:
>>> [   67.980732] kvm: enabling virtualization on CPU0 failed
>>> 
>>> 
>>> I commented out the if() and return, and I added 2 printk's there for
>>> debugging, and now that's what I see in dmesg when I start kvm:
>>> 
>>> [ 3341.740112] efer is 3329
>>> [ 3341.740113] efer is 3329
>>> [ 3341.740117] efer is 3329
>>> [ 3341.740119] EFER_SVME is 4096
>>> [ 3341.740121] EFER_SVME is 4096
>>> [ 3341.740124] EFER_SVME is 4096
>>> [ 3341.740130] efer is 3329
>>> [ 3341.740132] EFER_SVME is 4096
>>> 
>>> In hex the values are 0x1000 and 0x0d01
>>> 
>>> KVM has been working well on this machine before, and it still works
>>> well after commenting that part out.
>>> 
>>> I am not sure what the value of this register is supposed to be, but are
>>> you sure
>>> 
>>> if (efer & EFER_SVME)
>>> 
>>> is the right condition?
>> 
>> According to the printks you show above the & condition should never apply.
>> 
>> Are you 100% sure you don't have vmware, virtualbox, parallels, whatever running in parallel on that machine?
> 
> Definitely. I have virtualbox installed, but haven't used it in months.
> The others I don't use at all, so they are not installed either.
> 
> There is nothing running which could cause that. Behaviour is the same
> when I don't log into KDE but just try this without X, where nearly
> nothing is started.
> 
> I noted something more now: When I comment it out once, and start kvm
> like that, and then remove the comments again, then it works. So I guess
> the dmesg parts I wrote were not perfect. It's more like:
> 
> I: After reboot, with debugging printk and if condition:
> 
> [   42.089423] efer is d01
> [   42.089425] efer is d01
> [   42.089428] efer is d01
> [   42.089430] EFER_SVME is 1000
> [   42.089431] EFER_SVME is 1000
> [   42.089433] EFER_SVME is 1000
> [   42.089436] efer is 1d01
> [   42.089438] EFER_SVME is 1000
> [   42.089440] kvm: enabling virtualization on CPU0 failed
> 
> II: debugging printk, no if condition:
> 
> [  317.355519] efer is d01
> [  317.355522] efer is d01
> [  317.355524] efer is d01
> [  317.355527] EFER_SVME is 1000
> [  317.355528] EFER_SVME is 1000
> [  317.355531] EFER_SVME is 1000
> [  317.355534] efer is 1d01
> [  317.355536] EFER_SVME is 1000
> 
> III: debugging printk and if condition:
> 
> [  421.955433] efer is d01
> [  421.955437] efer is d01
> [  421.955440] efer is d01
> [  421.955442] EFER_SVME is 1000
> [  421.955443] EFER_SVME is 1000
> [  421.955445] EFER_SVME is 1000
> [  421.955449] efer is d01
> [  421.955451] EFER_SVME is 1000
> 
> 
> 
> This is without reboots in between. So now before I use the commented
> out version for the first time, it doesnt work, the 2nd time it works.
> Maybe some initialization problem...

It looks like one of your CPUs has EFER_SVME enabled on bootup already. I'm not aware of code clearing EFER, so if there's garbage in there on boot it stays there.

Could you please add the current CPU number to your printk? I bet it's always the same one.
If that's the case I'd say you have a broken BIOS or bootloader.


Alex