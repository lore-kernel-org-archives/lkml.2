Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756103Ab1D2Pq2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Apr 2011 11:46:28 -0400
Received: from smtp105.prem.mail.ac4.yahoo.com ([76.13.13.44]:27246 "HELO
	smtp105.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753950Ab1D2Pq0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Apr 2011 11:46:26 -0400
X-Yahoo-SMTP: OIJXglSswBDfgLtXluJ6wiAYv6_cnw--
X-YMail-OSG: mttw6xAVM1k.mpglkDuZWhjeoIWuRrPDdJjgrYzgisqLxAq
 uq6bHeir80JKgfKPcZBuXJiZlmwhU.uNW3YIXN0cP6iPVlvU174Gpl6jaoOv
 LuegeGge2K85zO21nVEuZmUb.Q6K5yZt.N7ey5n5ajevJJTq6Zimpy1J4fGU
 lsn26GfmxtHHqhEm.mW.4GJS.Xd52P27rQbmtUFIdOupD92_aOGMSEGfn8h4
 DR2IrnQ7YXdhPy3rYNvjSGVpyJIOhXwneuRMApTDrv9JtGln57wV2ycTmanW
 961YiPly8XrXg7e2yXZ5Jh1e_.jRx6Q8o.S7G7cb4x0JQI7ZIP2ANe7muF86
 Yc6LLi34Gxr0ylf3nSUoy6b2x0mJb59fGnw--
X-Yahoo-Newman-Property: ymail-3
Message-ID: <4DBADD4C.9040507@schaufler-ca.com>
Date: Fri, 29 Apr 2011 08:46:20 -0700
From: Casey Schaufler <casey@schaufler-ca.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 6.0; en-US; rv:1.9.2.15) Gecko/20110303 Thunderbird/3.1.9
MIME-Version: 1.0
To: Roberto Sassu <roberto.sassu@polito.it>
CC: Tyler Hicks <tyhicks@linux.vnet.ibm.com>,
        linux-security-module@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, dhowells@redhat.com, jmorris@namei.org,
        zohar@linux.vnet.ibm.com, safford@watson.ibm.com,
        kirkland@canonical.com, ecryptfs-devel@lists.launchpad.net,
        eparis@redhat.com, sds@tycho.nsa.gov, selinux@tycho.nsa.gov,
        viro@zeniv.linux.org.uk, john.johansen@canonical.com,
        apparmor@lists.ubuntu.com, Casey Schaufler <casey@schaufler-ca.com>
Subject: Re: [RFC][PATCH 0/7] File descriptor labeling
References: <201104291139.37489.roberto.sassu@polito.it>
In-Reply-To: <201104291139.37489.roberto.sassu@polito.it>
X-Enigmail-Version: 1.1.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 4/29/2011 2:39 AM, Roberto Sassu wrote:
> Sorry for resending, it was rejected by the mailing lists due to
> the html formatting.
>
>
> On Thursday, April 28, 2011 07:37:29 PM Casey Schaufler wrote:
>> On 4/28/2011 5:35 AM, Roberto Sassu wrote:
>>> On Thursday, April 28, 2011 01:27:19 AM Tyler Hicks wrote:
>>>> On Wed Apr 27, 2011 at 01:19:55PM -0700, Casey Schaufler <casey@schaufler-ca.com> wrote:
>>>>> On 4/27/2011 5:34 AM, Roberto Sassu wrote:
>>>>>> File descriptor labeling issue
>>>>>>
>>>>>> Actually SELinux and SMACK assign to file descriptors the same label of the
>>>>>> opening process and use it in LSM hooks security_file_permission(),
>>>>>> security_file_fcntl() and others to verify if the 'current' process has the
>>>>>> rights to perform the requested operation.
>>>>>>
>>>>>> Using the credentials of the 'current' process may be not appropriate in
>>>>>> case a file descriptor is opened by a kernel service (i.e. a filesystem)
>>>>>> and made shared among user processes. For instance, in a system with
>>>>>> SELinux and eCryptfs, if the process A opens an encrypted file, eCryptfs
>>>>>> obtains a file descriptor to access the correspondent inode in the lower
>>>>>> filesystem, labeled with the A's label.
>>>>>>
>>>>>> If the process B accesses the same encrypted file, it needs the 'use'
>>>>>> permission on the A's label other than permissions for the lower inode.
>>>>>> However, if B is the first accessing process, A needs the 'use' permission
>>>>>> on the B's label.
>>>>> I am having trouble understanding the argument. I will pose my
>>>>> question in Smack terms, as I can speak most definitively in them.
>>>>>
>>>>> A process running with a Smack label "A" creates a file, and that
>>>>> file gets labeled "A", as it ought. If eCryptfs is behaving correctly
>>>>> this ought not change. If eCryptfs in encrypting the label it needs
>>>>> to do so in such a way as to be able to decrypt it prior to
>>>>> presentation to the vfs layer, where it will be used in an access
>>>>> check. When the process running with a Smack label "B" comes along
>>>>> the vfs code will check the fetched and possibly decrypted "A"
>>>>> against "B" and, unless there is an explicit Smack rule in place
>>>>> granting "B" access to "A", fail.
>>>>>
>>>>> What is the problem? What is eCryptfs doing that prevents this
>>>>> from working?
>>>> Hi Casey - I think what Roberto is getting at is the way eCryptfs uses
>>>> only one lower file per eCryptfs inode. Imagine that there are 5
>>>> files open for ~/secret/foo at the eCryptfs layer, only 1 file is going
>>>> to be open in the lower filesystem and all eCryptfs file operations will
>>>> be multiplexed through it.
>>>>
>>>> To make things more complicated, if the eCryptfs file is opened for
>>>> writing, the lower file must be opened for reading and writing. This is
>>>> because a write operation requires eCryptfs to vfs_read() from the lower
>>>> filesystem, decrypt that data and then vfs_write() the new data.
>>>>
>>>> If the lower file can't be opened O_RDWR by the calling process, the
>>>> request is handed off to a kernel thread to open the lower file on
>>>> behalf of the calling process. It is definitely ugly.
>>>>
>>>> Roberto, I hope I correctly described the situation that you're trying
>>>> to address. Can you tell me why we can't have a 1:1 mapping of eCryptfs
>>>> files to lower files?
>>>>
>>>> Instead of having just one lower file attached to the eCryptfs inode, we
>>>> could have a list of opened files. There would be one for each eCryptfs
>>>> file that was opened. ecryptfs_writepage() would have to pick, in a
>>>> somewhat random fashion, one of the lower files to use. Of course, we
>>>> would still need to solve the problem of opening the lower file O_RDWR
>>>> when the calling process is only allowed write access (I may have just
>>>> answered my own question of why the 1:1 mapping technique won't solve
>>>> this problem).
>>>>
>>> Hi Tyler
>>>
>>> i think the 1:1 mapping isn't necessary at least from the security perspective.
>>> Since eCryptfs is a stacked filesystem access control is performed on
>>> both the upper and the lower layer.
>>> ECryptfs relies on the lower filesystem for the management of extended
>>> attributes, so this means that the security label of both the upper and
>>> the lower inodes is the same (however this is not the current behavior
>>> in SELinux, which assigns the label 'ecryptfs_t' to the upper inode).
>> Where does this assignment occur?
>>
> Hi Casey
>
> The assignment happens at the inode's initialization time and depends on
> the behavior configured for a specific filesystem.
> The SELinux reference policy actually configures static labeling for inodes
> in the eCryptfs filesystem while for example allows ext4 inodes to be
> initialized using extended attributes.

So how about changing eCryptfs (Goodness, but I hate camelCase) to
properly support extended attributes? That would seem a better
approach than mucking up the entire LSM. You still have to deal
with the SELinux policy, but I don't see you getting away without
doing something with that in any case.

>>> In my view, for this reason the access control checks can be performed
>>> only at the upper layer, letting eCryptfs full privileges to access inodes
>>> in the lower filesystem.
>> On this point I most strongly disagree.
>>
>> The behavior of a filesystem and the data that it uses to determine
>> that behavior is wrought with complex interactions which may include
>> but are not limited to caching, read-aheads, garbage collection,
>> and various side effects of access control. If eCryptfs needs to go
>> mucking about with the data used by the underlying filesystem it is
>> not stacking properly. A stacked filesystem has no business whatever
>> changing the data of the underlying filesystem.
>>
> Ok, probably i have to go more in deep to explain how access control is
> performed on eCryptfs. I'm talking for the SELinux's case, so SELinux experts
> can correct me if i'm wrong.
>
> First, i want to use extended attributes to initialize an eCryptfs inode, so
> both the upper and the lower inodes have the same security context
> because eCryptfs calls the *xattr() methods of the underlying filesystem.

OK, you could create your own xattr functions that do whatever credential
mucking they need to and then call the underlying file system's version.
It is possible that the work the NFS people have been doing for xattr
support (I haven't seen much on this lately, is it still active? Anyone?)
would prove instructive.

> Then, the process A accesses the eCryptfs inode 'I'. On the upper layer access
> control is performed using the credentials of the 'current' process and the
> security context of I.
>
> If the process is allowed to access the upper inode, eCryptfs opens the lower
> inode, presenting its own credentials with the type 'kernel_t'.

So eCryptfs provides its own process context. When you say "open" do you
mean open(2) or something else? A little precision goes a long way in these
discussions.

> Then, SELinux
> checks if 'kernel_t' can access the inode with the security context of 'I'.

Why doesn't eCryptfs provide the credentials of 'I'? In the kernel you
can do what you will.

> If so,
> eCryptfs obtains a file descriptor which, in this patch set, is labeled using the
> same credentials it provided at open time and binds it to the upper inode.
>
> Suppose for a moment that A is working on the eCryptfs inode 'I' and the process
> B requests the same inode. ECryptfs uses the already opened file descriptor and
> B will be granted to open the requested inode if:
>
> - B has the 'open' permission on the upper inode 'I';
>
>
> and can perform read/write operations if:
>
> - B has the 'read' and 'write' permissions on the upper inode 'I';
> - B is allowed to use the file descriptor opened by eCryptfs ('kernel_t').
> - B has the 'read' and 'write' permissions on the lower inode I;
>
>
> What i miss to say in my previous email is that even if eCryptfs is granted
> to access inodes in the lower filesystem with full privileges, user processes
> still need the permission to deal with the lower inode, but the check on the
> upper inode is sufficient because the security context is the same.

Right, but what I don't understand is why you can't use existing
mechanisms to achieve this? NFS manages (mostly).

>> Excuse my ignorance for a moment. Is eCryptfs a user mode filesystem,
>> or in the kernel properly? The behavior makes it sound like the former
>> while the interfaces you're requesting make it seem like the latter.

I'll repeat the question because it matters.

