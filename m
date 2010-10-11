Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753990Ab0JKJmS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Oct 2010 05:42:18 -0400
Received: from mail-ww0-f42.google.com ([74.125.82.42]:55740 "EHLO
	mail-ww0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753840Ab0JKJmQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Oct 2010 05:42:16 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:from:date
         :x-google-sender-auth:message-id:subject:to:cc:content-type
         :content-transfer-encoding;
        b=rWM+FDe6mL7+8rNWOHTX7lrvwmYLFgxXNK73YLSzJ34d+MDgindINQM4m/1nkTXGyd
         qE+2pOthlW0vAcAZyIcz1roUpoyZEUJ5ORcZJ2a+jM0jIskh3TiohNpjJVDC01nKCYUy
         VYiXJPuIWOsoEN+Tk5at3QCc4IB93lLj5FuX0=
MIME-Version: 1.0
In-Reply-To: <20101006173141.GB18479@shell>
References: <20100920180404.939991832@szeredi.hu> <201009281025.00727.agruen@suse.de>
 <20100930215114.GD490@shell> <201010011134.57594.agruen@suse.de> <20101006173141.GB18479@shell>
From: Michal Suchanek <hramrach@centrum.cz>
Date: Mon, 11 Oct 2010 11:41:54 +0200
X-Google-Sender-Auth: PC7nJoR6OwOb41bA6amTkFe3VnQ
Message-ID: <AANLkTindWa7gLbcfF1GE8jcwkJ0bgOGbvuSS2nWSHkLj@mail.gmail.com>
Subject: Re: [PATCH 6/7 v3] overlay: hybrid overlay filesystem prototype
To: Valerie Aurora <vaurora@redhat.com>
Cc: Andreas Gruenbacher <agruen@suse.de>, Andy Whitcroft <apw@canonical.com>,
        Scott James Remnant <scott@canonical.com>,
        Vladimir Dronnikov <dronnikov@gmail.com>,
        Felix Fietkau <nbd@openwrt.org>, Miklos Szeredi <miklos@szeredi.hu>,
        linuxram@us.ibm.com, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, neilb@suse.de, viro@zeniv.linux.org.uk
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 6 October 2010 19:31, Valerie Aurora <vaurora@redhat.com> wrote:
> On Fri, Oct 01, 2010 at 11:34:57AM +0200, Andreas Gruenbacher wrote:
>> On Thursday 30 September 2010 23:51:15 Valerie Aurora wrote:
>> >
>> > Hm, this was a pretty basic assumption for me - that you'd want to
>> > construct a topmost image offline that would be "merged" with the
>> > lower layers.  So, for example:
>> >
>> > Topmost layer contains:
>> >
>> > /etc/hostname
>> >
>> > Lower layers contain everything else in /etc/.  So /etc/ would exist
>> > on the topmost layer at the time of union mount, but we would want it
>> > to be transparent.  But if we created a new dir *during* the union
>> > mount, it would be opaque.
>> >
>> > What was your model?
>>
>> The prevalent use case probably is to start out with an empty topmost layer on
>> top of an existing file system.  When things are modified, changes obviously
>> go into the topmost layer.  Additional layers can later be stacked on top of
>> that, turning the previous topmost layer into a read-only lower layer.
>>
>> Overlaying preexisting file systems doesn't seem that important; users
>> commonly should be able to start out with an empty topmost layer instead.  To
>
> Okay, that surprises me.  Let me check my assumptions.  I cc'd several
> people who seem to be actively using unionfs or aufs in ways that we
> want union mounts to replace.  Do you start out with an empty topmost
> file system in most cases?  Or do you prepopulate with some files in
> dirs you want to be transparent?

In all the cases I used a union mouont I started with a blank top layer.

I commonly use it to make a readonly live CD filesystem writable so
that a system can run on top of it.

I tried to use a union to build a software on top of a readonly source
directory.

In both these cases the filesystem starts empty and is only populated
by writing into the union mount.

In both these cases the top layer is often thrown away after use but
can be saved to reconstruct the union later, either as filesystem
image or a tar/cpio archive. In the case of archive reconstructing the
union includes prepopulating the top layer.

In both these cases the bottom should typically not change between
unmounting the union and reconstructing it again but it may change if
the live CD or sources are updated between unmounting the union and
reconstructing it again. There are number of reasons why this may
break for the user but if unionmount does not support falling through
existing top level directories then this is one more reason, perhaps
unexpected.

Fine control over transparency of top layer is not required in most of
these use cases. A simple flag that can perhaps be specified on mount
and/or saved in superblock could say if the filesystem contains union
entries or not. In a plain non-union filesystem all directories are
transparent and whiteouts or fallthrus are invalid. In a filesystem
previously mounted as top union layer all directories are opaque. This
should cover most cases except the case when the opaque top layer can
hide updates to the bottom layer.

Note that whatever is implemented saving the top layer in an archive
is not likely to work because currently no archiving programs would
support whiteouts or fallthrus. With aufs this can work when these are
saved as specially named files or a separate table.

Either way implications of the current implementation should be
clearly documented.

I don't think manipulating the transparency and whiteouts would be
used for much but testing.

I can imagine some specialized tool that compares two bottom images
and then manipulates a saved top layer such that the differences
between the bottom images become visible when the new bottom is
overlayed with the saved top.  Still it will not work in all cases
because changes between top and bottom and between old and new bottom
cannot always be merged automatically. A companion 'revert' tool which
changes an entry in mounted union into a fallthru would come handy I
guess.

I doubt many people would use anything this complex.

Thanks

Michal
