Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758660Ab1CaQXt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Mar 2011 12:23:49 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:46134 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753330Ab1CaQXr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Mar 2011 12:23:47 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=mE+h/51L6cEhkNbQyNAtNhVtgokHnovBcfEfgSSqqO0i4Kwcg3E0LfoBcBIJ6ZvufX
         ++cHOG0GXUqyYxGcNQs8NKoMqydsRQtsxEIh4MRBL+KXMQIx5fN1pcsICBLeoIXMmuho
         uS2AO7ovuza1PfxUT1i1fW87br+Gzmv9l661E=
Date: Thu, 31 Mar 2011 09:23:38 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Dmitry Torokhov <dtor@vmware.com>
Cc: Bryan Schumaker <bjschuma@netapp.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Trond Myklebust <Trond.Myklebust@netapp.com>
Subject: Re: 2.6.39-rc1 regression: NFS - unable to mount some shares
 (bisected)
Message-ID: <20110331162338.GA32296@core.coreip.homeip.net>
References: <8A85A9B4-D801-476F-B280-CE2B1D04277B@vmware.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8A85A9B4-D801-476F-B280-CE2B1D04277B@vmware.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Bryan,

On Wed, Mar 30, 2011 at 03:31:44PM -0700, Dmitry Torokhov wrote:
> Hi Bryan,
> 
> It is actually one of autofs + NIS, mounts that is failing.
> 

Some more data about NFS problemi I am seeing. With an older kernel I
get:

[dtor@dtor-d630 ~]$ sudo mount -v build-toolchain:/toolchain /mnt/
mount: no type was given - I'll assume nfs because of the colon
mount.nfs: timeout set for Thu Mar 31 09:17:38 2011
mount.nfs: trying text-based options 'vers=4,addr=10.17.52.98,clientaddr=10.20.94.47'
mount.nfs: mount(2): Operation not permitted
mount.nfs: trying text-based options 'addr=10.17.52.98'
mount.nfs: prog 100003, trying vers=3, prot=6
mount.nfs: trying 10.17.52.98 prog 100003 vers 3 prot TCP port 2049
mount.nfs: prog 100005, trying vers=3, prot=17
mount.nfs: trying 10.17.52.98 prog 100005 vers 3 prot UDP port 693
build-toolchain:/toolchain on /mnt type nfs (rw)

The failing kernel does it like this:

[dtor@dtor-ws ~]$ sudo mount -v build-toolchain:/toolchain /mnt
mount: no type was given - I'll assume nfs because of the colon
mount.nfs: timeout set for Thu Mar 31 09:14:22 2011
mount.nfs: trying text-based options 'vers=4,addr=10.17.52.98,clientaddr=10.20.94.123'
mount.nfs: mount(2): Resource temporarily unavailable
mount.nfs: Resource temporarily unavailable

And I can mount it successfully if I explicitly request V3:

[dtor@dtor-ws ~]$ sudo mount -v -o nfsvers=3 build-toolchain:/toolchain /mnt/
mount: no type was given - I'll assume nfs because of the colon
mount.nfs: timeout set for Thu Mar 31 09:22:57 2011
mount.nfs: trying text-based options 'nfsvers=3,addr=10.17.52.98'
mount.nfs: prog 100003, trying vers=3, prot=6
mount.nfs: trying 10.17.52.98 prog 100003 vers 3 prot TCP port 2049
mount.nfs: prog 100005, trying vers=3, prot=17
mount.nfs: trying 10.17.52.98 prog 100005 vers 3 prot UDP port 693
build-toolchain:/toolchain on /mnt type nfs (rw,nfsvers=3)

The mounts that succeed automatically with the newer kernel do like
this:

[dtor@dtor-ws ~]$ sudo mount -v pa-home:/home2 /mnt/
mount: no type was given - I'll assume nfs because of the colon
mount.nfs: timeout set for Thu Mar 31 09:20:01 2011
mount.nfs: trying text-based options 'vers=4,addr=10.17.4.25,clientaddr=10.20.94.123'
mount.nfs: mount(2): Protocol not supported
mount.nfs: trying text-based options 'addr=10.17.4.25'
mount.nfs: prog 100003, trying vers=3, prot=6
mount.nfs: trying 10.17.4.25 prog 100003 vers 3 prot TCP port 2049
mount.nfs: prog 100005, trying vers=3, prot=17
mount.nfs: trying 10.17.4.25 prog 100005 vers 3 prot UDP port 1234
pa-home:/home2 on /mnt type nfs (rw)

I am not sure why in failing case we are seeing "resource temporarily
unavailable" instead of "protocol not supported".

Thanks.

-- 
Dmitry
