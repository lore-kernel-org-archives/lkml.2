Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756685Ab0GNMrj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jul 2010 08:47:39 -0400
Received: from e36.co.us.ibm.com ([32.97.110.154]:56316 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756515Ab0GNMrg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jul 2010 08:47:36 -0400
Subject: Re: [Linux-ima-user] [RFC][PATCH] ima: add default rule for
 initramfs files
From: Mimi Zohar <zohar@linux.vnet.ibm.com>
To: Roberto Sassu <roberto.sassu@polito.it>
Cc: Seiji Munetoh <seiji.munetoh@gmail.com>,
        linux-ima-user@lists.sourceforge.net,
        linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org,
        Eric Paris <eparis@redhat.com>, Shaz <shazalive@gmail.com>
In-Reply-To: <4C3D76AE.6090509@polito.it>
References: <1278428902-27079-1-git-send-email-roberto.sassu@polito.it>
	 <1278594883.3313.33.camel@localhost.localdomain>
	 <AANLkTilMKH5M0d8iyACTDLMwZb1WgyJVrd9e04H2cy95@mail.gmail.com>
	 <AANLkTinWK9mX6lVUvWzgbh7QQ3ZItnrUE4WBJEkOqm2q@mail.gmail.com>
	 <AANLkTilI8klNawzxVc-wxREJwktBKW2G4GvYeyMueGJM@mail.gmail.com>
	 <4C3D76AE.6090509@polito.it>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 14 Jul 2010 08:47:12 -0400
Message-ID: <1279111632.2292.47.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 (2.28.3-1.fc12) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-07-14 at 10:34 +0200, Roberto Sassu wrote:
> On 07/14/2010 08:29 AM, Seiji Munetoh wrote:
> > On Wed, Jul 14, 2010 at 2:42 PM, Shaz<shazalive@gmail.com>  wrote:
> >    
> >>
> >> On Wed, Jul 14, 2010 at 3:08 AM, Seiji Munetoh<seiji.munetoh@gmail.com>
> >> wrote:
> >>      
> >>> On Thu, Jul 8, 2010 at 10:14 PM, Mimi Zohar<zohar@linux.vnet.ibm.com>
> >>> wrote:
> >>>        
> >>>> On Tue, 2010-07-06 at 17:08 +0200, Roberto Sassu wrote:
> >>>>          
> >>>>> This patch modifies the default policy shipped with IMA, in order to
> >>>>> avoid measurements
> >>>>> of files in the initial ramdisk. Those files can be measured early in
> >>>>> the boot process
> >>>>> by the bootloader.
> >>>>> The patch applies to latest version of the mainline kernel 2.6.35-rc4.
> >>>>>            
> >>>> Yes, the initramfs measurements are therefore redundant, as they're
> >>>> already included in the initramfs measurement, but perhaps, as the
> >>>> number of initramfs is very limited and the individual file measurements
> >>>> supplies additional information, it wouldn't hurt to keep the individual
> >>>> file measurements as well.  These measurements could potentially help in
> >>>> identifying initramfs changes.
> >>>>
> >>>> Would appreciate other opinions before accepting this change.
> >>>>          
> >>> The hash value of the initramfs is unstable since it was generated
> >>> at the time of kernel installation.
> >>> So still I want to check  the individual used file in initramfs.
> >>>        
> >> If initrd is measured by boot loader then changes to individual files should
> >> not be measured as this IS redundant. Use the new hash of the initrd as an
> >> integrity metric. Why would this not be enough?
> >>      
> > This depends on remote verifier.
> > Creating the initramfs is client side task and  the hash value of initramfs
> > will vary each clients.
> >
> > For me, validation of  current measurements is easier than validation of
> > initramfs. And it seems the overhead of this redundancy is less painful.
> >
> > But some system can validate (or trust) the initramfs measured by IPL.
> > So, I would suggest that add Kconfig option to change the default policy.

If your other suggestion, below, of adding fsmagic info to the
measurement list doesn't suffice, then defining a new command line
option, in addition to 'ima_tcb', shouldn't be a problem.

> > IMHO, if the eventlog contains fsmagic information for each measurements.
> > Verifier can skip the validation of RAMFS measurement easily.

Ok, so this takes us back to the discussion on what should be included
in the ima-nglong template. So far we have the hash algorithm(sha1,
sha256, sha512), the hash digest, filename, uid/gid, and LSM obj/subj
labels.  We can add the fsmagic after the uid/gid.  Before upstreaming
the template patches, is there anything else?  (Remember, the more info
we add, the larger the measurement list becomes, so we shouldn't add
anything superfluously.)
    
> This is true, the initramfs's digest cannot be validated by a remote 
> verifier. But in my opinion there are three main reasons for don't 
> include those files in the measurement list.
> First, this is a readonly system and measures don't change in time; so 
> if you create the image under a controlled environment and its digest 
> doesn't change you can assert it will behave correctly.

A 'controlled environment' might exist for some device types, but not
for others.

> Second, including those measurements may be very confusing for a 
> verifier since there may be multiple versions of the same object (the 
> initramfs changes very rarely in respect to other files).

Extending the ima-nglong template to include fsmagic, as Seiji
suggested, should resolve this problem.

> Lastly, a pratical use of IMA is to load a custom policy. The better 
> place to do that is the initramfs but measurements cannot be taken until 
> the policy is loaded. The only way, as Shaz mentioned in a previous 
> email, to keep track of all actions made during the boot process is that 
> you have the initramfs image measured early by the boot loader.

Yes, nobody is suggesting otherwise.  If adding fsmagic doesn't suffice,
then in addition to 'ima_tcb', another command line option could be
defined which doesn't measure initramfs files.

Mimi

