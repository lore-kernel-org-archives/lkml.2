Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754571Ab0HKJFv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Aug 2010 05:05:51 -0400
Received: from 27.mail-out.ovh.net ([91.121.30.210]:42768 "HELO
	27.mail-out.ovh.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752162Ab0HKJFu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Aug 2010 05:05:50 -0400
X-Greylist: delayed 398 seconds by postgrey-1.27 at vger.kernel.org; Wed, 11 Aug 2010 05:05:49 EDT
Message-ID: <4C626659.5040704@example.com>
Date: Wed, 11 Aug 2010 10:59:05 +0200
From: Piotr Hosowicz <piotr@hosowicz.com>
Reply-To: piotr@hosowicz.com
Organization: hosowicz.com
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.10) Gecko/20100620 Icedove/3.0.5
MIME-Version: 1.0
To: Sripathi Kodi <sripathik@in.ibm.com>
CC: divya <dipraksh@linux.vnet.ibm.com>, LKML <linux-kernel@vger.kernel.org>,
        linuxppc-dev@ozlabs.org, Stephen Rothwell <sfr@canb.auug.org.au>
Subject: Re: kernel version 2.6.35-git10 build failure
References: <4C624F7F.3070608@linux.vnet.ibm.com> <20100811132313.3d6c7f27@sripathi.in.ibm.com>
In-Reply-To: <20100811132313.3d6c7f27@sripathi.in.ibm.com>
Content-Type: text/plain; charset=ISO-8859-2; format=flowed
Content-Transfer-Encoding: 8bit
X-Ovh-Tracer-Id: 7375488816881365434
X-Ovh-Remote: 83.24.80.145 (dmy145.neoplus.adsl.tpnet.pl)
X-Ovh-Local: 213.186.33.20 (ns0.ovh.net)
X-Spam-Check: DONE|U 0.5/N
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11.08.2010 09:53, Sripathi Kodi wrote:
> On Wed, 11 Aug 2010 12:51:35 +0530
> divya<dipraksh@linux.vnet.ibm.com>  wrote:
>
>> Hi,
>>
>> Today kernel(version 2.6.35-git10 -commitid 3d30701b58970) build fails with following error on both system x and p
>>
>>     fs/9p/vfs_inode.c: In function 'v9fs_vfs_setattr_dotl':
>>     fs/9p/vfs_inode.c:1267: error: implicit declaration of function 'inode_setattr'
>>     make[2]: *** [fs/9p/vfs_inode.o] Error 1
>>     make[2]: *** Waiting for unfinished jobs....
>>     make[1]: *** [fs/9p] Error 2
>>     make[1]: *** Waiting for unfinished jobs....
>>     make: *** [fs] Error 2
>>     make: *** Waiting for unfinished jobs....
>>
>> Seems like the commit 87d7845aa0b is the corrupt which added the function v9fs_vfs_setattr_dotl()
>
> Yes, it is a problem I created. Stephen Rothwell has already fixed it.
> Al Viro has sent a git pull request to Linus today with the fix in it.
> Here is the patch you need: http://lkml.org/lkml/2010/6/21/442

I fail to apply the patch.

aapi205:/usr/src/linux# patch -p1 < ../9p-patch.txt
patching file fs/9p/vfs_inode.c
Hunk #1 FAILED at 1052.
1 out of 1 hunk FAILED -- saving rejects to file fs/9p/vfs_inode.c.rej

aapi205:/usr/src/linux# cat fs/9p/vfs_inode.c.rej
--- fs/9p/vfs_inode.c
+++ fs/9p/vfs_inode.c
@@ -1052,10 +1052,19 @@
                 return PTR_ERR(fid);

         retval = p9_client_setattr(fid, &p9attr);
-       if (retval >= 0)
-               retval = inode_setattr(dentry->d_inode, iattr);
+       if (retval < 0)
+               return retval;

-       return retval;
+       if ((iattr->ia_valid & ATTR_SIZE) &&
+           iattr->ia_size != i_size_read(dentry->d_inode)) {
+               retval = vmtruncate(dentry->d_inode, iattr->ia_size);
+               if (retval)
+                       return retval;
+       }
+
+       setattr_copy(dentry->d_inode, iattr);
+       mark_inode_dirty(dentry->d_inode);
+       return 0;
  }

  /**

I must be doing something wrong way.

Regards,

Piotr Hosowicz

-- 
Z cyklu "Uroki demokracji", czyli pytania i odpowiedzi w teledurniejach:
- Jak± walutê maj± Indie?
- Ramadan.
NP: Patrick O'Hearn - Approaching Summit
NB: 2.6.35-git9
