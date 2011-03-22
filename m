Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754828Ab1CVQOM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Mar 2011 12:14:12 -0400
Received: from cantor2.suse.de ([195.135.220.15]:49695 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753821Ab1CVQOJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Mar 2011 12:14:09 -0400
Date: Tue, 22 Mar 2011 17:14:05 +0100
From: Jan Kara <jack@suse.cz>
To: "Alex,Shi" <alex.shi@intel.com>
Cc: Jeff Moyer <jmoyer@redhat.com>, Jan Kara <jack@suse.cz>,
        Corrado Zoccolo <czoccolo@gmail.com>,
        "Li, Shaohua" <shaohua.li@intel.com>, Vivek Goyal <vgoyal@redhat.com>,
        "tytso@mit.edu" <tytso@mit.edu>,
        "jaxboe@fusionio.com" <jaxboe@fusionio.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Chen, Tim C" <tim.c.chen@intel.com>
Subject: Re: [performance bug] kernel building regression on 64 LCPUs
 machine
Message-ID: <20110322161405.GB19716@quack.suse.cz>
References: <AANLkTinAeQMy-OoYYpbYeX=EjZ_-uT=67Ktk1PbE=A7_@mail.gmail.com>
 <x49hbbmpqbo.fsf@segfault.boston.devel.redhat.com>
 <20110302094246.GA7496@quack.suse.cz>
 <x491v2p4i0u.fsf@segfault.boston.devel.redhat.com>
 <20110302211748.GF7496@quack.suse.cz>
 <x49lj0x0zve.fsf@segfault.boston.devel.redhat.com>
 <20110304153248.GC2649@quack.suse.cz>
 <x49d3m6j35j.fsf@segfault.boston.devel.redhat.com>
 <x491v2mivv6.fsf@segfault.boston.devel.redhat.com>
 <1300779499.30136.353.camel@debian>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="tKW2IUtsqtDRztdT"
Content-Disposition: inline
In-Reply-To: <1300779499.30136.353.camel@debian>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--tKW2IUtsqtDRztdT
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue 22-03-11 15:38:19, Alex,Shi wrote:
> On Sat, 2011-03-05 at 02:27 +0800, Jeff Moyer wrote:
> > Jeff Moyer <jmoyer@redhat.com> writes:
> > 
> > > Jan Kara <jack@suse.cz> writes:
> > >
> > >> I'm not so happy with ext4 results. The difference between ext3 and ext4
> > >> might be that amount of data written by kjournald in ext3 is considerably
> > >> larger if it ends up pushing out data (because of data=ordered mode) as
> > >> well. With ext4, all data are written by filemap_fdatawrite() from fsync
> > >> because of delayed allocation. And thus maybe for ext4 WRITE_SYNC_PLUG
> > >> is hurting us with your fast storage and small amount of written data? With
> > >> WRITE_SYNC, data would be already on it's way to storage before we get to
> > >> wait for them...
> > >
> > >> Or it could be that we really send more data in WRITE mode rather than in
> > >> WRITE_SYNC mode with the patch on ext4 (that should be verifiable with
> > >> blktrace). But I wonder how that could happen...
> > >
> > > It looks like this is the case, the I/O isn't coming down as
> > > synchronous.  I'm seeing a lot of writes, very few write sync's, which
> > > means that the write stream will be preempted by the incoming reads.
> > >
> > > Time to audit that fsync path and make sure it's marked properly, I
> > > guess.
> > 
> > OK, I spoke too soon.  Here's the blktrace summary information (I re-ran
> > the tests using 3 samples, the blktrace is from the last run of the
> > three in each case):
> > 
> > Vanilla
> > -------
> > fs_mark: 307.288 files/sec
> > fio: 286509 KB/s
> > 
> > Total (sde):
> >  Reads Queued:     341,558,   84,994MiB  Writes Queued:       1,561K,    6,244MiB
> >  Read Dispatches:  341,493,   84,994MiB  Write Dispatches:  648,046,    6,244MiB
> >  Reads Requeued:         0               Writes Requeued:        27
> >  Reads Completed:  341,491,   84,994MiB  Writes Completed:  648,021,    6,244MiB
> >  Read Merges:           65,    2,780KiB  Write Merges:      913,076,    3,652MiB
> >  IO unplugs:       578,102               Timer unplugs:           0
> > 
> > Throughput (R/W): 282,797KiB/s / 20,776KiB/s
> > Events (sde): 16,724,303 entries
> > 
> > Patched
> > -------
> > fs_mark: 278.587 files/sec
> > fio: 298007 KB/s
> > 
> > Total (sde):
> >  Reads Queued:     345,407,   86,834MiB  Writes Queued:       1,566K,    6,264MiB
> >  Read Dispatches:  345,391,   86,834MiB  Write Dispatches:  327,404,    6,264MiB
> >  Reads Requeued:         0               Writes Requeued:        33
> >  Reads Completed:  345,391,   86,834MiB  Writes Completed:  327,371,    6,264MiB
> >  Read Merges:           16,    1,576KiB  Write Merges:        1,238K,    4,954MiB
> >  IO unplugs:       580,308               Timer unplugs:           0
> > 
> > Throughput (R/W): 288,771KiB/s / 20,832KiB/s
> > Events (sde): 14,030,610 entries
> > 
> > So, it appears we flush out writes much more aggressively without the
> > patch in place.  I'm not sure why the write bandwidth looks to be higher
> > in the patched case... odd.
> 
> Jan:
> Do you have new idea on this? 
  I was looking at the block traces for quite some time but I couldn't find
the reason why fs_mark is slower with my patch. Actually, looking at the
data now, I don't even understand how fs_mark can report lower files/sec
values.

Both block traces were taken for 300 seconds. From the above stats, we see
that on both kernels, we wrote 6.2 GB over that time. Looking at more
detailed stats I made, fs_mark processes wrote 4094 MB on vanilla kernel
and 4107 MB on the patched kernel. Given that they just sequentially create
and fsync 64 KB files, files/sec ratio should be about the same with both
kernels. So I'm really missing how fs_mark arrives at different files/sec
values or how with such different values it happens that the amount written
is actually the same. Anyone has any idea? 

Looking at how fs_mark works and at differences in trace files - could it
be that the difference is caused by a difference in how log files each
fs_mark thread is writing are flushed? Or possibly by IO caused unlinking
of created files somehow leaking to the time of the next measured fs_mark
run in one case and not the other one? Jeff, I suppose the log files of
fs_mark processes are on the same device as the test directory, aren't
they - that might explain the flusher thread doing IO? The patch below
should limit the interactions. If you have time to test fs_mark with this
patch applied - does it make any difference?

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR

--tKW2IUtsqtDRztdT
Content-Type: text/x-patch; charset=us-ascii
Content-Disposition: attachment; filename="fs_mark.c.diff"

--- a/fs_mark.c.orig	2011-03-22 17:04:52.194716633 +0100
+++ b/fs_mark.c	2011-03-22 17:06:11.910716645 +0100
@@ -1353,6 +1353,11 @@ int main(int argc, char **argv, char **e
 		print_iteration_stats(log_file_fp, &iteration_stats,
 				      files_written);
 		loops_done++;
+		/*
+		 * Flush dirty data to avoid interaction between unlink / log
+		 * file handling and the next iteration
+		 */
+		sync();
 
 	} while (do_fill_fs || (loop_count > loops_done));
 

--tKW2IUtsqtDRztdT--
