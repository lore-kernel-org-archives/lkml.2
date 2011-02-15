Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754670Ab1BOLkj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Feb 2011 06:40:39 -0500
Received: from mail1.slb.deg.dub.stisp.net ([84.203.253.98]:19562 "HELO
	mail1.slb.deg.dub.stisp.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753787Ab1BOLkg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Feb 2011 06:40:36 -0500
X-Greylist: delayed 401 seconds by postgrey-1.27 at vger.kernel.org; Tue, 15 Feb 2011 06:40:35 EST
Message-ID: <4D5A63DE.3040600@draigBrady.com>
Date: Tue, 15 Feb 2011 11:30:38 +0000
From: =?UTF-8?B?UMOhZHJhaWcgQnJhZHk=?= <P@draigBrady.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.8) Gecko/20100227 Thunderbird/3.0.3
MIME-Version: 1.0
To: Marti Raudsepp <marti@juffo.org>
CC: Chris Mason <chris.mason@oracle.com>, Josef Bacik <josef@redhat.com>,
        btrfs hackers <linux-btrfs@vger.kernel.org>,
        Kernel hackers <linux-kernel@vger.kernel.org>, 8001@debbugs.gnu.org
Subject: Re: btrfs: compression breaks cp and cross-FS mv, FS_IOC_FIEMAP bug?
References: <AANLkTinZNk1j94rEMVdvRtjr2Sa-C7VpQOGHrvrY8Hph@mail.gmail.com> <20110213155730.GK19533@dhcp231-156.rdu.redhat.com> <AANLkTi=Rj_3MmLawJj-K8u+pGbT_NZzqzVGFOsvOK8eC@mail.gmail.com> <20110213161329.GL19533@dhcp231-156.rdu.redhat.com> <1297695521-sup-9460@think> <AANLkTi=N8DiusfP6Rey=Cx4qjUSbiLS3jnbjASGQ=Lcx@mail.gmail.com>
In-Reply-To: <AANLkTi=N8DiusfP6Rey=Cx4qjUSbiLS3jnbjASGQ=Lcx@mail.gmail.com>
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 14/02/11 17:58, Marti Raudsepp wrote:
> On Mon, Feb 14, 2011 at 17:01, Chris Mason <chris.mason@oracle.com> wrote:
>> Or, it could just be delalloc ;)
> 
> I suspect delalloc. After creating the file, filefrag reports "1
> extent found", but for some reason it doesn't actually print out
> details of the extent.

That's a bug in `filefrag -v` that I noticed independently yesterday.
Without -v it will correctly report 0 extents.
I've already suggested a patch to fix upstream.

> After a "sync" call, the extent appears and "cp" starts working as expected:

About that sync.
I've noticed on ext4 loop back at least (and I suspect BTRFS is the same)
that specifying FIEMAP_FLAG_SYNC (which cp does) is ineffective.
I worked around this for cp tests by explicitly syncing with:
dd if=/dev/null of=foo conv=notrunc,fdatasync

> % rm -f foo bar
> % echo foo > foo
> % sync
> % filefrag -v foo
> Filesystem type is: 9123683e
> File size of foo is 4 (1 block, blocksize 4096)
>  ext logical physical expected length flags
>    0       0        0            4096 not_aligned,inline,eof
> foo: 1 extent found
> % cp foo bar
> % hexdump bar
> 0000000 6f66 0a6f
> 0000004

OK that's fine for normal files.
cp (from coreutils >= 8.10) may still do the wrong thing
as it currently ignores FIEMAP_EXTENT_DATA_ENCRYPTED and FIEMAP_EXTENT_ENCODED
as I've already reported:
http://www.mail-archive.com/linux-btrfs@vger.kernel.org/msg08356.html
I'd appreciate some `filefrag -v` output from a large compressed file.

cheers,
Pádraig.
