Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751974Ab0CRKNw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Mar 2010 06:13:52 -0400
Received: from mx1.redhat.com ([209.132.183.28]:61907 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751182Ab0CRKNu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Mar 2010 06:13:50 -0400
Message-ID: <4BA1FC80.2000401@redhat.com>
Date: Thu, 18 Mar 2010 12:12:16 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.8) Gecko/20100301 Fedora/3.0.3-1.fc12 Thunderbird/3.0.3
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Anthony Liguori <anthony@codemonkey.ws>,
       "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Sheng Yang <sheng@linux.intel.com>, linux-kernel@vger.kernel.org,
       kvm@vger.kernel.org, Marcelo Tosatti <mtosatti@redhat.com>,
       oerg Roedel <joro@8bytes.org>, Jes Sorensen <Jes.Sorensen@redhat.com>,
       Gleb Natapov <gleb@redhat.com>, Zachary Amsden <zamsden@redhat.com>,
       ziteng.huang@intel.com, Arnaldo Carvalho de Melo <acme@redhat.com>,
       Fr?d?ric Weisbecker <fweisbec@gmail.com>
Subject: Re: [RFC] Unify KVM kernel-space and user-space code into a single
 project
References: <20100316112500.GA5337@elte.hu> <4B9F77E7.2060101@redhat.com> <20100316122903.GA8831@elte.hu> <4B9F7C6A.3070207@redhat.com> <20100316130840.GA24808@elte.hu> <4B9FBA8B.8020200@codemonkey.ws> <20100316173940.GA23859@elte.hu> <4BA00F1F.1090907@codemonkey.ws> <20100317081041.GC16374@elte.hu> <4BA1E24B.6090904@redhat.com> <20100318085607.GB2157@elte.hu>
In-Reply-To: <20100318085607.GB2157@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/18/2010 10:56 AM, Ingo Molnar wrote:
> * Avi Kivity<avi@redhat.com>  wrote:
>
>    
>> On 03/17/2010 10:10 AM, Ingo Molnar wrote:
>>      
>>>        
>>>> It's about who owns the user interface.
>>>>
>>>> If qemu owns the user interface, than we can satisfy this in a very
>>>> simple way by adding a perf monitor command.  If we have to support third
>>>> party tools, then it significantly complicates things.
>>>>          
>>> Of course illogical modularization complicates things 'significantly'.
>>>        
>> Who should own the user interface then?
>>      
> If qemu was in tools/kvm/ then we wouldnt have such issues. A single patch (or
> series of patches) could modify tools/kvm/, arch/x86/kvm/, virt/ and
> tools/perf/.
>    

We would have exactly the same issues, only they would be in a single 
repository.  The only difference is that we could ignore potential 
alternatives to qemu, libvirt, and RHEV-M.  But that's not how kernel 
ABIs are developed, we try to make them general, not suited to just one 
consumer that happens to be close to our heart.

> Numerous times did we have patches to kernel/perf_event.c that fixed some
> detail, also accompanied by a tools/perf/ patch fixing another detail. Having
> a single 'culture of contribution' is a powerful way to develop.
>    

In fact kvm started out in a single repo, and it certainly made it easy 
to bring it up in baby steps.  But we've long outgrown that.  Maybe the 
difference is that perf is still new and thus needs tight cooperation.  
If/when perf gains a real GUI, I doubt more than 1% of the patches will 
touch both kernel and userspace.

> It turns out kernel developers can be pretty good user-space developers as
> well and user-space developers can be pretty good kernel developers as well.
> Some like to do both - as long as it's all within a single project.
>    

Very childish of them.  If someone wants to contribute to a userspace 
project, they can swallow their pride and send patches to a non-kernel 
mailing list and repository.

> The moment any change (be it as trivial as fixing a GUI detail or as complex
> as a new feature) involves two or more packages, development speed slows down
> to a crawl - while the complexity of the change might be very low!
>    

Why is that?

I the maintainers of all packages are cooperative and responsive, then 
the patches will get accepted quickly.  If they aren't, development will 
be slow.  It isn't any different from contributing to two unrelated 
kernel subsystems (which are in fact in different repositories until the 
next merge window).

> Also, there's the harmful process that people start categorizing themselves
> into 'I am a kernel developer' and 'I am a user space programmer' stereotypes,
> which limits the scope of contributions artificially.
>    

You're encouraging this with your proposal.  You're basically using the 
glory of kernel development to attract people to userspace.

>>> Fast forward to 2010. The kernel side of KVM is maximum goodness - by far
>>> the worst-quality remaining aspects of KVM are precisely in areas that you
>>> mention: 'if we have to support third party tools, then it significantly
>>> complicates things'. You kept Qemu as an external 'third party' entity to
>>> KVM, and KVM is clearly hurting from that - just see the recent KVM
>>> usability thread for examples about suckage.
>>>        
>> Any qemu usability problems are because developers (or their employers) are
>> not interested in fixing them, not because of the repository location.  Most
>> kvm developer interest is in server-side deployment (even for desktop
>> guests), so there is limited effort in implementing a virtualbox-style GUI.
>>      
> The same has been said of oprofile as well: 'it somewhat sucks because we are
> too server centric', 'nobody is interested in good usability and oprofile is
> fine for the enterprises'. Ironically, the same has been said of Xen usability
> as well, up to the point KVM came around.
>
> What was the core of the problem was a bad design and a split kernel-side
> user-side tool landscape.
>    

I can accept the bad design (not knowing any of the details), but how 
can the kernel/user split affect usability?

> In fact i think saying that 'our developers only care about the server' is
> borderline dishonest, when at the same time you are making it doubly sure (by
> inaction) that it stays so: by leaving an artificial package wall between
> kernel-side KVM and user-side KVM and not integrating the two technologies.
>    

The wall is maybe four nanometers high.  Please be serious.  If someone 
wants to work on qemu usability all they have to do is to clone the 
repository and start sending patches to qemu-devel@.  What's gained by 
putting it in the kernel repository?  You're saving a minute's worth of 
clone, and that only for people who already happen to be kernel developers.

> You'll never know what heights you could achieve if you leave that wall there
> ...
>    

I truly don't know.  What highly usable GUIs were developed in the kernel?

> Furthermore, what should be realized is that bad usability hurts "server
> features" just as much. Most of the day-to-day testing is done on the desktop
> by desktop oriented testers/developers. _Not_ by enterprise shops - they tend
> to see the code years down the line to begin with ...
>
> Yes, a particular feature might be server oriented, but a good portion of our
> testing is on the desktop and everyone is hurting from bad usability and this
> puts limits on contribution efficiency.
>    

I'm not saying that improved usability isn't a good thing, but time 
spent on improving the GUI is time not spent on the features that we 
really want.

Desktop oriented users also rarely test 16 vcpu guests with tons of RAM 
exercising 10Gb NICs and a SAN.  Instead they care about graphics 
performance for 2vcpu/1GB guests.

> As the patch posted in _this very thread demonstrates it_, it is doubly more
> difficult to contribute a joint KVM+Qemu feature, because it's two separate
> code bases, two contribution guidelines, two release schedules. While to the
> user it really is just one and the same thing. It should be so for the
> developer as well.
>    

It's hard to contribute a patch that goes against the architecture of 
the system, where kvm deals with cpu virtualization, qemu (or 
theoretically another tool) manages a guest, and libvirt (or another 
tool) manages the host.  You want a list of guests to be provided by 
qemu or the kernel, and that simply isn't how the system works.

> Put in another way: KVM's current split design is making it easy to contribute
> server features (because the kernel side is clean and cool), but also makes it
> artificially hard to contribute desktop features: because the tooling side
> (Qemu) is 'just another package', is separated by a package and maintenance
> wall


Most server oriented patches in qemu/kvm have gone into qemu, not kvm 
(simply because it sees many more patches overall).  It isn't hard to 
contribute to 'just another package', I have 1700 packages installed on 
my desktop and only one of them is a kernel.

Anyway your arguments apply equally well to gedit.

> and is made somewhat uncool by a (as some KVM developers have pointed out
> in this thread) quirky codebase.
>    

The qemu codebase is in fact quirky, but cp won't solve it.  Only long 
patchsets to qemu-devel@.

> (the rest of your points are really a function of this fundamental
> disagreement)
>    

I disagree.

-- 
error compiling committee.c: too many arguments to function

