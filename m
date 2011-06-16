Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758132Ab1FPRKI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jun 2011 13:10:08 -0400
Received: from mail-gx0-f174.google.com ([209.85.161.174]:35904 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756054Ab1FPRKC convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jun 2011 13:10:02 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=vrfy.org; s=google;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=BFw5qPigjMafKXrbPU4ZY31nixVaPdtXtoKSRevH2nr247IhXlg8FrsJidPKxwB9VX
         12G07KiiGqp02LaNU3JeFmBlbo+qwZL1w16v0bQvuJUCPv5sifA3YLWp05Fj9J9ppQE9
         kA9l0B1p+UboeIydlQY8gkKtoUOxKWnccZG/c=
MIME-Version: 1.0
In-Reply-To: <1308241506.2436.44.camel@mulgrave>
References: <20110615081610.2237.44767.stgit@ltc233.sdl.hitachi.co.jp>
 <20110615081627.2237.9620.stgit@ltc233.sdl.hitachi.co.jp> <20110615153337.GA10160@kroah.com>
 <4DF9F11F.705@hitachi.com> <20110616154129.GA31498@kroah.com>
 <1308239454.2436.34.camel@mulgrave> <20110616161442.GA32113@kroah.com> <1308241506.2436.44.camel@mulgrave>
From: Kay Sievers <kay.sievers@vrfy.org>
Date: Thu, 16 Jun 2011 19:09:46 +0200
Message-ID: <BANLkTi=qHhzwGfp4v8B1CAmT+gtA=sOgvw@mail.gmail.com>
Subject: Re: [PATCH 1/3] [RFC] genhd: add a new attribute in device structure
To: James Bottomley <James.Bottomley@hansenpartnership.com>
Cc: Greg KH <greg@kroah.com>, Nao Nishijima <nao.nishijima.xt@hitachi.com>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        jcm@redhat.com, hare@suse.de, stefanr@s5r6.in-berlin.de,
        yrl.pp-manager.tt@hitachi.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 16, 2011 at 18:25, James Bottomley
<James.Bottomley@hansenpartnership.com> wrote:
> On Thu, 2011-06-16 at 09:14 -0700, Greg KH wrote:
>> On Thu, Jun 16, 2011 at 11:50:54AM -0400, James Bottomley wrote:
>> > > And again, why not just fix the userspace tools?  That is trivial to do
>> > > so and again, could have been done by now in the years this has been
>> > > discussed.
>> >
>> > So I can summarise where I think we are in these discussions:
>> >
>> > We provide the ability to give all kernel devices a "preferred name".
>> > By default this will be the device name the kernel would have originally
>> > assigned.  the dev_printk's will use the preferred name, and it will be
>> > modifiable from user space.  All the kernel will do is print out
>> > whatever it is ... no guarantees of uniqueness or specific format will
>> > be made.  Since we're only providing one preferred_name file, the kernel
>> > can only have one preferred name for a device at any given time
>> > (although it is modifiable on the fly as many times as the user
>> > chooses).
>> >
>> > The design is to use this preferred name to implement what Hitachi wants
>> > in terms of persistent name, but we don't really care.
>> >
>> > All userspace naming will be taken care of by the usual udev rules, so
>> > for disks, something like /dev/disk/by-preferred/<fred> which would be
>> > the usual symbolic link.
>>
>> No, udev can not create such a link after the preferred name is set, as
>> it has no way of knowing that the name was set.
>
> It can if we trigger a uevent.  Note: I'm not advocating this ... I'd be
> equally happy having whatever sets the kernel name create the link (or
> tickle udev to create it).  We definitely require device links, though,
> to get this to work.

The tool which sets the name would be udev, I guess. What would be a
good example where this name would come from?

If these links are to be used in reality, all that must work from the
very first steps during early boot in initramfs I guess. Adding names
later to existing devices by some other tool, doesn't sound too
convincing.

I'm not opposed to the idea of a 'pretty name' in general, but I like
to see some real world example that makes sense, is better than what
we have, provides some generally useful infrastructure, solves a real
problem, and see how it can be consistently used.

I mean doing all that in contrast to simply have, per example: udev
always log the current 'kernel name' -> 'all symlinks' to syslog, and
be able to parse all history after that log entry from syslog just
fine. That can probably be done today already just fine, with a few
lines of udev rules.

I guess the real problem is to finally to admit that free-text syslog
is not the way to reliably do things in the future. We need proper
debug/error reporting from the kernel and not 'printk() from driver
hackers to admins' to read and try to make sense out of it. The real
answer is probably a 'smart' kernel-syslog and a reliable channel with
structured data from the kernel to userspace. All that 'pretty name'
stuff look suspiciously like a paper-over the real problem of a
missing general infrastructure which nobody wants to address for
years. Guess it's time to leave the UNIX stone age behind us  nothing
against fancy text files filled with driver debug someone thought to
be useful, I added enough of that myself, but I doubt that the 'pretty
names' are the thing that can solve what enterprise use cases are
looking for since a very long time.

>> > This will ensure that kernel output and udev input are consistent.  It
>> > will still require that user space utilities which derive a name for a
>> > device will need modifying to print out the preferred name.
>>
>> It also doesn't solve the issue of userspace wanting to use such a
>> "preferred" name in the command line of tools, as there will not be a
>> link back to the "kernel" name directly in /dev/.
>
> Right ... most tools use the name they're given (and all variants
> including the preferred one have links in /dev), which means they will
> show the preferred name by default (if they were given that name as
> input).  The only problem is tools that attempt to derive a device name,
> which is quite a small subset.

The most important tool for disks, mount(8) canonicalizes the link
names to the primary device node name. :)

>> So as userspace tools will still need to be fixed, I don't see how
>> adding a kernel file for this is going to help any.  Well, a bit in that
>> the kernel log files will look "different", but again, that really isn't
>> a problem that userspace couldn't also solve with no kernel changes
>> needed.
>
> This is true, but I think for the small effort it takes to implement the
> feature in-kernel compared with what we'd have to do to the
> distributions to get it implemented in userspace (we'd need klogd to do
> the conversion for dmesg ... I'm entirely unclear what we need to modify
> for /proc/partitions, etc.) the benefit outweighs the cost.
>
> Additionally, since renaming is something users seem to want (just look
> at net interfaces), if we can make this work, we now have a definitive
> answer to point people at.

The way netifs are done today is a pretty good example how we did
things wrong. We need to step back here, and probably put the naming
of on-board net interfaces right into the kernel, and do nothing for
interfaces which are not explicitly configured. The races that arrise
with renaming we just can't handle properly. But anyway, that's a
different story.

Netifs are very different too, in the sense that firewall rules use
the names _in_ the kernel. We don't have such requirements for block
devices, unlike netifs, they are always just a number to the kernel.

And network interfaces have concept of a 'pretty name' in the kernel
already, it's: /sys/class/net/*/ifalias. And it is not commonly used,
because people want not a single but multiple names at the same time,
or just want the primary name set. :)

Kay
