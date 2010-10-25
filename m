Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759470Ab0JYTkS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Oct 2010 15:40:18 -0400
Received: from shards.monkeyblade.net ([198.137.202.13]:55005 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751518Ab0JYTkR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Oct 2010 15:40:17 -0400
Message-ID: <4CC5DCBB.1070505@kernel.org>
Date: Mon, 25 Oct 2010 12:38:35 -0700
From: "J.H." <warthog9@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.12) Gecko/20100907 Fedora/3.0.7-1.fc12 Lightning/1.0b2pre Thunderbird/3.0.7
MIME-Version: 1.0
To: John Stoffel <john@stoffel.org>
CC: Eric Paris <eparis@redhat.com>, linux-kernel@vger.kernel.org,
        linux-security-module@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        hch@infradead.org, zohar@us.ibm.com, david@fromorbit.com,
        jmorris@namei.org, kyle@mcmartin.ca, hpa@zytor.com,
        akpm@linux-foundation.org, torvalds@linux-foundation.org,
        mingo@elte.hu, viro@zeniv.linux.org.uk
Subject: Re: [PATCH 01/11] IMA: use rbtree instead of radix tree for inode
 information cache
References: <20101025184118.20504.24290.stgit@paris.rdu.redhat.com> <19653.55494.240658.165153@quad.stoffel.home>
In-Reply-To: <19653.55494.240658.165153@quad.stoffel.home>
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.3 (shards.monkeyblade.net [198.137.202.13]); Mon, 25 Oct 2010 12:38:37 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/25/2010 12:21 PM, John Stoffel wrote:
>>>>>> "Eric" == Eric Paris <eparis@redhat.com> writes:
> 
> Eric> The IMA code needs to store the number of tasks which have an
> Eric> open fd granting permission to write a file even when IMA is not
> Eric> in use.  It needs this information in order to be enabled at a
> Eric> later point in time without losing it's integrity garantees.
> 
> This sounds completely wrong to me.  If I disable IMA (but have the
> sucker compiled in due to a vendor...) I don't want *any* overhead,
> and this is speaking using my SysAdmin hat for people who do EDA
> design work, and having fast systems is key for us.  IMA is NOT.  We
> disable SELINUX too, because of the overhead and the maintenance
> nightmare.

I'll second both points.  If IMA is disabled, but compiled in, it *HAS*
to consume 0 resources.  It's defective by design if something that is
only useful to 1% of the userbase (guesstimating) consumes even 1% of
the resources on any and all machines that are deployed with it.  It's
just plain wasteful of power, cooling, ram, compute resources, etc.

Keep in mind distros are going to err on the side of compiling things in
(either into the kernel or as modules) because there is a customer
*SOMEWHERE* that wants it.  Penalizing the rest of us, and forcing us
(effectively) to buy more ram, is not a good option.

> If IMA isn't enabled right from the get-go, how can you ensure
> integrity?  And how can you ensure integrity if root is compromised?
> If root can disable IMA, screw around with a file, then turn on IMA
> again without the change being guarrentteed to be noticed (and not
> because the attacked didn't do the attack perfectly!) what's the use?
> 
> How does this help any?  
> 
> To quote from:
> http://domino.research.ibm.com/comm/research_people.nsf/pages/sailer.ima.html
> 
>     What IMA is not
> 
>     IMA is not controlling your system. IMA is non-intrusive and is best
>     described as an independent observer collecting integrity information
>     of loaded code or sensitive application files on demand. Consequently,
>     IMA does not prevent a system from illegal behavior that might
>     compromise the system including the integrity measurement architecture
>     itself. Recognizing the danger of being by-passed, IMA simply
>     invalidates its own measurement list by invalidating the TPM integrity
>     aggregate and thereby rendering the evidence useless (non-verifiable)
>     until it is reset during the next system reboot. For example, if
>     applications write directly to a device (/dev/hda, /dev/sda) or kernel
>     memory (/dev/kmem), then IMA invalidates the TPM aggregate.
> 
>     IMA is not a Digital Rights Management tool either. IMA collects
>     evidence on the local system, which can be used for many purposes but
>     whose release is fully controlled by the local system. It is getting
>     harder to lie about what you are running when you use IMA; no doubt
>     about it. However, if system security is going to be reality, systems
>     that lie at will seem not a convincing alternative in a distributed
>     environment where the weakest link determines the security of the
>     distributed service. The price to pay is that properties must be
>     established securely and that the balance between use and abuse of
>     knowledge about such properties as well as the validity of requiring
>     such evidence (e.g., before connecting a system to a video-on-demand
>     service) must be controlled by rules that are enforced the same way
>     they are in other areas of our daily life (most likely by laws).
> 
> 
> So basically, IMA is super duper tripwire with the ability to allow
> some remote system to come in and ask for your Hashes.  And if you
> screw around with it, it immediately disables itself.  
> 
> Which seems to fly in the face of your claim that it needs to be able
> to re-enable itself by tracking open inodes even when disabled.

Wouldn't an enterprising root-kit snag root, muck with IMA and then muck
with other files?  I mean I'm happy that it will trip-wire the
incompetent or old root kits, but if root can enable/disable this
outside of boot it's completely pointless.

> 
> Eric>   At the moment that means we store a little bit of data about
> Eric> every inode in a cache.  We use a radix tree key'd on the
> Eric> inode's memory address.  Dave Chinner pointed out that a radix
> Eric> tree is a terrible data structure for such a sparse key space.
> Eric> This patch switches to using an rbtree which should be more
> Eric> efficient.
> 
> As the number of inodes goes up (say during a backup which reads
> them...) won't the size of this cache go up as well, even when IMA is
> disabled?  Why is this overhead even needed?  

Ignore backups, file servers and large webservers (read: basically
kernel.org's *ENTIRE* infrastructure) basically trips over this case.
To throw fire on the whole thing, if there are 100 mirrors in a
mirroring infrastructure (not uncommon for some distros) and they all
have IMA disabled but compiled in, and they are all rsyncing data (say a
distro release is ongoing) you are talking about a huge amount of waste
across all those machines.

I'd argue disabled = takes up no resources, that's what a sysadmin is
going to generally expect particularly for something that not many of
them are going to want to take advantage of.

Just my $0.02usd anyway.

- John 'Warthog9' Hawley
