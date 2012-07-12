Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030774Ab2GLTl1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jul 2012 15:41:27 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:63202 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030749Ab2GLTlZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jul 2012 15:41:25 -0400
From: Denys Vlasenko <vda.linux@gmail.com>
To: Oleg Nesterov <oleg@redhat.com>
Subject: Re: [PATCH] Extend core dump note section to contain file names of mapped files
Date: Thu, 12 Jul 2012 21:41:18 +0200
User-Agent: KMail/1.8.2
Cc: Denys Vlasenko <vda.linux@gmail.com>, linux-kernel@vger.kernel.org,
        "Jonathan M. Foote" <jmfoote@cert.org>,
        "H. J. Lu" <hjl.tools@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>, Andi Kleen <ak@suse.de>,
        Denys Vlasenko <dvlasenk@redhat.com>,
        Jan Kratochvil <jan.kratochvil@redhat.com>
References: <CAK1hOcNWo2mV2nKmVEuzKzEs7pCveFCBFWrYSrMbj4Y7M8zQ6Q@mail.gmail.com> <20120711151513.GA9314@redhat.com>
In-Reply-To: <20120711151513.GA9314@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201207122141.18772.vda.linux@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 11 July 2012 17:15, Oleg Nesterov wrote:
> On 07/11, Denys Vlasenko wrote:
> >
> > I propose to save this information in core dump, as a new note
> > in note segment.
> 
> Denys, I am in no position to discuss whether we need this change or not,
> format, etc. I'll only try to comment the code.
> 
> And please do not use the attachments ;)
> 
> > +static void fill_files_note(struct memelfnote *note)
> > +{
> > +	struct vm_area_struct *vma;
> > +	struct file *file;
> > +	unsigned count, word_count, size, remaining;
> > +	long *data;
> > +	long *start_end_ofs;
> > +	char *name;
> > +
> > +	count = 0;
> > +	for (vma = current->mm->mmap; vma != NULL; vma = vma->vm_next) {
> > +		file = vma->vm_file;
> > +		if (!file)
> > +			continue;
> > +		count++;
> > +		if (count >= MAX_FILE_NOTE_SIZE / 64) /* paranoia check */
> > +			goto err;
> 
> Why this check? If count is huge, then...
> 
> > +	size = count * 64;
> > +	word_count = 2 + 3 * count;
> > + alloc:
> > +	if (size >= MAX_FILE_NOTE_SIZE) /* paranoia check */
> > +		goto err;
> 
> we should detect this case before the first alloc?

Unless count * 64 overflows an int :)
As I said in the comment: paranoia.

Perhaps that's TOO MUCH of paranoia. Removing.

> > +	size = (size + PAGE_SIZE - 1) & (-PAGE_SIZE);
> 
> Well, I'd suggest PAGE_MASK instead of -PAGE_SIZE. Better yet,
> 
> 	size = round_up(size, PAGE_SIZE);
> 
> > +		if (remaining == 0) {
> > + try_new_size:
> > +			vfree(data);
> > +			size = size * 5 / 4;
> > +			goto alloc;
> > +		}
> > +		filename = d_path(&file->f_path, name, remaining);
> > +		if (IS_ERR(filename)) {
> > +			if (PTR_ERR(filename) == -ENAMETOOLONG)
> > +				goto try_new_size;
> 
> This looks like unnecessary complication to me, or I missed something.
> d_path(..., buflen) should handle the "buflen == 0" case correctly, so
> afacics you can remove the "if (remaining == 0)" block and move this
> free-and-goto-alloc code under the -ENAMETOOLONG check.
> 
> > +		while ((remaining--, *name++ = *filename++) != '\0')
> > +			continue;
> 
> Well, perhaps this is just me... but this looks a bit too complex
> to me ;) I won't insist, but
> 
> 		do
> 			remaining--;
> 		while ((*name++ = *filename++));
> 
> looks more understandable, imho.

Okay.


> Or even
> 
> 		/* d_path() fills the end of the buffer */
> 		remaining = name - filename;
> 		strcpy(name, filename);

This does not advance "name" pointer... oh...
it's actually clever! But it'll fail if we took

                        /* continue; -- WRONG, we must have COUNT elements */
                        filename = "";
                }

branch just above... I will use an open-coded loop for now.

Sending v2 in a moment.

-- 
vda
